-- Private duo formation. Apply only to an isolated development project.
create table public.duos (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  ended_at timestamptz
);

create table public.duo_members (
  duo_id uuid not null references public.duos (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  primary key (duo_id, user_id)
);

create unique index duo_members_one_active_duo_per_user_idx
  on public.duo_members (user_id)
  where left_at is null;

create index duo_members_active_duo_idx
  on public.duo_members (duo_id)
  where left_at is null;

create table public.duo_invites (
  id uuid primary key default gen_random_uuid(),
  duo_id uuid not null references public.duos (id) on delete cascade,
  inviter_id uuid not null references auth.users (id) on delete cascade,
  token_hash bytea not null unique,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null,
  consumed_at timestamptz,
  cancelled_at timestamptz,
  check (expires_at > created_at)
);

create index duo_invites_pending_duo_idx
  on public.duo_invites (duo_id, expires_at)
  where consumed_at is null and cancelled_at is null;

alter table public.duos enable row level security;
alter table public.duo_members enable row level security;
alter table public.duo_invites enable row level security;

revoke all on table public.duos, public.duo_members, public.duo_invites
  from anon, authenticated;

create or replace function public.assert_duo_eligible(requested_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if requested_user_id is null
    or not exists (
      select 1
      from public.profiles
      where user_id = requested_user_id
        and adult_confirmed_at is not null
    )
    or not exists (
      select 1
      from public.consents
      where user_id = requested_user_id
        and purpose = 'sensitive_preferences'
        and revoked_at is null
    ) then
    raise exception 'onboarding_incomplete';
  end if;
end;
$$;

create or replace function public.create_duo_invite()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
  current_duo_id uuid;
  active_members integer;
  new_invite_id uuid;
  raw_token text;
  invitation_expires_at timestamptz := now() + interval '24 hours';
begin
  if actor_id is null then
    raise exception 'authentication_required';
  end if;

  perform pg_advisory_xact_lock(hashtext(actor_id::text));
  perform public.assert_duo_eligible(actor_id);

  select duo_id
  into current_duo_id
  from public.duo_members
  where user_id = actor_id and left_at is null;

  if current_duo_id is not null then
    perform 1
    from public.duos
    where id = current_duo_id and ended_at is null
    for update;

    if not found then
      raise exception 'duo_not_available';
    end if;

    select count(*)
    into active_members
    from public.duo_members
    where duo_id = current_duo_id and left_at is null;

    if active_members <> 1 then
      raise exception 'already_in_active_duo';
    end if;

    update public.duo_invites
    set cancelled_at = now()
    where duo_id = current_duo_id
      and consumed_at is null
      and cancelled_at is null;
  else
    insert into public.duos default values returning id into current_duo_id;
    insert into public.duo_members (duo_id, user_id)
    values (current_duo_id, actor_id);
  end if;

  raw_token := encode(extensions.gen_random_bytes(32), 'hex');
  insert into public.duo_invites (
    duo_id,
    inviter_id,
    token_hash,
    expires_at
  )
  values (
    current_duo_id,
    actor_id,
    extensions.digest(raw_token, 'sha256'),
    invitation_expires_at
  )
  returning id into new_invite_id;

  return jsonb_build_object(
    'invite_id', new_invite_id,
    'invite_token', raw_token,
    'invite_expires_at', invitation_expires_at
  );
end;
$$;

create or replace function public.accept_duo_invite(invite_token text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
  invitation public.duo_invites%rowtype;
  active_members integer;
begin
  if actor_id is null then
    raise exception 'authentication_required';
  end if;

  if invite_token is null or length(trim(invite_token)) <> 64 then
    raise exception 'invalid_invite';
  end if;

  perform pg_advisory_xact_lock(hashtext(actor_id::text));
  perform public.assert_duo_eligible(actor_id);

  select *
  into invitation
  from public.duo_invites
  where token_hash = extensions.digest(trim(invite_token), 'sha256');

  if not found then
    raise exception 'invalid_invite';
  end if;

  perform 1
  from public.duos
  where id = invitation.duo_id and ended_at is null
  for update;

  if not found then
    raise exception 'invalid_invite';
  end if;

  select *
  into invitation
  from public.duo_invites
  where id = invitation.id
  for update;

  if not found
    or invitation.consumed_at is not null
    or invitation.cancelled_at is not null
    or invitation.expires_at <= now() then
    raise exception 'invalid_invite';
  end if;

  if invitation.inviter_id = actor_id then
    raise exception 'self_acceptance_not_allowed';
  end if;

  if exists (
    select 1
    from public.duo_members
    where user_id = actor_id and left_at is null
  ) then
    raise exception 'already_in_active_duo';
  end if;

  select count(*)
  into active_members
  from public.duo_members
  where duo_id = invitation.duo_id and left_at is null;

  if active_members <> 1 then
    raise exception 'invalid_invite';
  end if;

  insert into public.duo_members (duo_id, user_id)
  values (invitation.duo_id, actor_id);

  update public.duo_invites
  set consumed_at = now()
  where id = invitation.id;

  update public.duo_invites
  set cancelled_at = now()
  where duo_id = invitation.duo_id
    and id <> invitation.id
    and consumed_at is null
    and cancelled_at is null;
end;
$$;

create or replace function public.cancel_duo_invite(requested_invite_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
  target_duo_id uuid;
  invitation public.duo_invites%rowtype;
begin
  if actor_id is null then
    raise exception 'authentication_required';
  end if;

  perform pg_advisory_xact_lock(hashtext(actor_id::text));

  select duo_id
  into target_duo_id
  from public.duo_invites
  where id = requested_invite_id;

  if not found then
    raise exception 'invite_not_available';
  end if;

  perform 1
  from public.duos
  where id = target_duo_id and ended_at is null
  for update;

  if not found then
    raise exception 'invite_not_available';
  end if;

  select *
  into invitation
  from public.duo_invites
  where id = requested_invite_id
  for update;

  if not found
    or invitation.inviter_id <> actor_id
    or invitation.consumed_at is not null
    or invitation.cancelled_at is not null then
    raise exception 'invite_not_available';
  end if;

  update public.duo_invites
  set cancelled_at = now()
  where id = invitation.id;
end;
$$;

create or replace function public.get_my_duo()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
  current_duo_id uuid;
  active_members integer;
  invitation public.duo_invites%rowtype;
begin
  if actor_id is null then
    raise exception 'authentication_required';
  end if;

  select duo_id
  into current_duo_id
  from public.duo_members
  where user_id = actor_id and left_at is null;

  if current_duo_id is null then
    return jsonb_build_object('state', 'no_duo');
  end if;

  if not exists (
    select 1 from public.duos where id = current_duo_id and ended_at is null
  ) then
    return jsonb_build_object('state', 'no_duo');
  end if;

  select count(*)
  into active_members
  from public.duo_members
  where duo_id = current_duo_id and left_at is null;

  if active_members = 2 then
    return jsonb_build_object('state', 'active', 'duo_id', current_duo_id);
  end if;

  select *
  into invitation
  from public.duo_invites
  where duo_id = current_duo_id
    and inviter_id = actor_id
    and consumed_at is null
    and cancelled_at is null
    and expires_at > now()
  order by created_at desc
  limit 1;

  if found then
    return jsonb_build_object(
      'state', 'waiting_for_invite',
      'duo_id', current_duo_id,
      'pending_invite_id', invitation.id,
      'pending_invite_expires_at', invitation.expires_at
    );
  end if;

  return jsonb_build_object('state', 'waiting_for_invite', 'duo_id', current_duo_id);
end;
$$;

create or replace function public.leave_duo()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
  current_duo_id uuid;
begin
  if actor_id is null then
    raise exception 'authentication_required';
  end if;

  perform pg_advisory_xact_lock(hashtext(actor_id::text));

  select duo_id
  into current_duo_id
  from public.duo_members
  where user_id = actor_id and left_at is null;

  if current_duo_id is null then
    raise exception 'no_active_duo';
  end if;

  perform 1
  from public.duos
  where id = current_duo_id and ended_at is null
  for update;

  if not found then
    raise exception 'no_active_duo';
  end if;

  update public.duos
  set ended_at = now()
  where id = current_duo_id;

  update public.duo_members
  set left_at = now()
  where duo_id = current_duo_id and left_at is null;

  update public.duo_invites
  set cancelled_at = now()
  where duo_id = current_duo_id
    and consumed_at is null
    and cancelled_at is null;
end;
$$;

revoke all on function public.assert_duo_eligible(uuid) from public;
revoke all on function public.create_duo_invite() from public;
revoke all on function public.accept_duo_invite(text) from public;
revoke all on function public.cancel_duo_invite(uuid) from public;
revoke all on function public.get_my_duo() from public;
revoke all on function public.leave_duo() from public;

grant execute on function public.create_duo_invite() to authenticated;
grant execute on function public.accept_duo_invite(text) to authenticated;
grant execute on function public.cancel_duo_invite(uuid) to authenticated;
grant execute on function public.get_my_duo() to authenticated;
grant execute on function public.leave_duo() to authenticated;
