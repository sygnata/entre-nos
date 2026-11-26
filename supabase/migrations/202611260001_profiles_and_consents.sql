-- Authentication and onboarding foundations. Apply only to an isolated dev project.
create table public.profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  adult_confirmed_at timestamptz
);

create table public.consents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  policy_version text not null,
  purpose text not null check (purpose in ('sensitive_preferences')),
  granted_at timestamptz not null default now(),
  revoked_at timestamptz,
  unique (user_id, policy_version, purpose)
);

create index consents_user_active_idx
  on public.consents (user_id, purpose)
  where revoked_at is null;

alter table public.profiles enable row level security;
alter table public.consents enable row level security;

create policy "profiles_select_own"
  on public.profiles for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "consents_select_own"
  on public.consents for select to authenticated
  using ((select auth.uid()) = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function public.confirm_adulthood()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles
  set adult_confirmed_at = coalesce(adult_confirmed_at, now())
  where user_id = (select auth.uid());

  if not found then
    raise exception 'profile_not_found';
  end if;
end;
$$;

create or replace function public.grant_sensitive_preferences_consent(
  requested_policy_version text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if requested_policy_version is null or length(trim(requested_policy_version)) = 0 then
    raise exception 'invalid_policy_version';
  end if;

  insert into public.consents (user_id, policy_version, purpose, granted_at, revoked_at)
  values ((select auth.uid()), requested_policy_version, 'sensitive_preferences', now(), null)
  on conflict (user_id, policy_version, purpose)
  do update set granted_at = now(), revoked_at = null;
end;
$$;

create or replace function public.revoke_sensitive_preferences_consent(
  requested_policy_version text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.consents
  set revoked_at = now()
  where user_id = (select auth.uid())
    and policy_version = requested_policy_version
    and purpose = 'sensitive_preferences'
    and revoked_at is null;
end;
$$;

revoke all on function public.confirm_adulthood() from public;
revoke all on function public.grant_sensitive_preferences_consent(text) from public;
revoke all on function public.revoke_sensitive_preferences_consent(text) from public;
grant execute on function public.confirm_adulthood() to authenticated;
grant execute on function public.grant_sensitive_preferences_consent(text) to authenticated;
grant execute on function public.revoke_sensitive_preferences_consent(text) to authenticated;
