-- Run only against the isolated development project.
-- This test starts a read-only transaction and does not persist any data.
begin read only;

do $$
declare
  test_user_id uuid;
  other_user_id uuid;
  own_profile_count integer;
  other_profile_count integer;
  other_consent_count integer;
begin
  select user_id
  into test_user_id
  from public.profiles
  order by created_at
  limit 1;

  if test_user_id is null then
    raise exception 'rls_test_requires_at_least_one_profile';
  end if;

  select user_id
  into other_user_id
  from public.profiles
  where user_id <> test_user_id
  limit 1;

  other_user_id := coalesce(other_user_id, gen_random_uuid());

  execute 'set local role authenticated';
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', test_user_id::text, true);

  select count(*) into own_profile_count from public.profiles;
  if own_profile_count <> 1 then
    raise exception 'authenticated_user_cannot_read_own_profile';
  end if;

  perform set_config('request.jwt.claim.sub', other_user_id::text, true);
  select count(*) into other_profile_count from public.profiles;
  select count(*) into other_consent_count from public.consents;

  if other_profile_count <> 0 or other_consent_count <> 0 then
    raise exception 'authenticated_user_can_read_another_users_data';
  end if;

  execute 'reset role';

  if has_table_privilege('authenticated', 'public.profiles', 'insert')
    or has_table_privilege('authenticated', 'public.profiles', 'update')
    or has_table_privilege('authenticated', 'public.profiles', 'delete')
    or has_table_privilege('authenticated', 'public.consents', 'insert')
    or has_table_privilege('authenticated', 'public.consents', 'update')
    or has_table_privilege('authenticated', 'public.consents', 'delete') then
    raise exception 'authenticated_role_has_direct_write_privilege';
  end if;

  if has_table_privilege('anon', 'public.profiles', 'select')
    or has_table_privilege('anon', 'public.consents', 'select') then
    raise exception 'anonymous_role_has_table_read_privilege';
  end if;

  if has_function_privilege('anon', 'public.confirm_adulthood()', 'execute')
    or has_function_privilege(
      'anon',
      'public.grant_sensitive_preferences_consent(text)',
      'execute'
    ) then
    raise exception 'anonymous_role_has_rpc_execute_privilege';
  end if;
end;
$$;

select 'PASS: profiles/consents RLS and privileges verified' as result;

commit;
