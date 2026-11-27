-- Shorter human-shareable invite codes. Apply only after 202611270002 on an isolated development project.
-- Existing pending invitations use the prior 64-character format and must be
-- generated again after this migration.
update public.duo_invites
set cancelled_at = now()
where consumed_at is null
  and cancelled_at is null;

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
  raw_token text := '';
  random_byte integer;
  invitation_expires_at timestamptz := now() + interval '24 hours';
  alphabet constant text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
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

  while length(raw_token) < 16 loop
    random_byte := get_byte(extensions.gen_random_bytes(1), 0);
    if random_byte < 248 then
      raw_token := raw_token || substr(alphabet, (random_byte % 62) + 1, 1);
    end if;
  end loop;

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

  if invite_token is null
    or trim(invite_token) !~ '^[A-Za-z0-9]{16}$' then
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
