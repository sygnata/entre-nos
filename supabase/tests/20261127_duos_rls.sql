-- Run only after 202611270002_duos_and_invites.sql on the isolated development project.
-- Requires two confirmed, onboarded test accounts. All writes are rolled back.
begin;

do $$
declare
  first_user_id uuid;
  second_user_id uuid;
  invitation jsonb;
  invite_token text;
  first_status jsonb;
  second_status jsonb;
begin
  if has_table_privilege('anon', 'public.duos', 'select')
    or has_table_privilege('anon', 'public.duo_members', 'select')
    or has_table_privilege('anon', 'public.duo_invites', 'select') then
    raise exception 'anonymous_role_can_read_duo_tables';
  end if;

  if has_table_privilege('authenticated', 'public.duos', 'select')
    or has_table_privilege('authenticated', 'public.duo_members', 'select')
    or has_table_privilege('authenticated', 'public.duo_invites', 'select')
    or has_table_privilege('authenticated', 'public.duos', 'insert')
    or has_table_privilege('authenticated', 'public.duo_members', 'insert')
    or has_table_privilege('authenticated', 'public.duo_invites', 'insert') then
    raise exception 'authenticated_role_has_direct_duo_table_privilege';
  end if;

  if has_function_privilege('anon', 'public.create_duo_invite()', 'execute')
    or has_function_privilege('anon', 'public.accept_duo_invite(text)', 'execute')
    or has_function_privilege('anon', 'public.get_my_duo()', 'execute') then
    raise exception 'anonymous_role_can_execute_duo_rpc';
  end if;

  if not has_function_privilege('authenticated', 'public.create_duo_invite()', 'execute')
    or not has_function_privilege('authenticated', 'public.accept_duo_invite(text)', 'execute')
    or not has_function_privilege('authenticated', 'public.cancel_duo_invite(uuid)', 'execute')
    or not has_function_privilege('authenticated', 'public.get_my_duo()', 'execute')
    or not has_function_privilege('authenticated', 'public.leave_duo()', 'execute') then
    raise exception 'authenticated_role_cannot_execute_duo_rpc';
  end if;

  select p.user_id
  into first_user_id
  from public.profiles p
  where p.adult_confirmed_at is not null
    and not exists (
      select 1
      from public.duo_members dm
      where dm.user_id = p.user_id and dm.left_at is null
    )
    and exists (
      select 1
      from public.consents c
      where c.user_id = p.user_id
        and c.purpose = 'sensitive_preferences'
        and c.revoked_at is null
    )
  order by p.created_at
  limit 1;

  select p.user_id
  into second_user_id
  from public.profiles p
  where p.user_id <> first_user_id
    and p.adult_confirmed_at is not null
    and not exists (
      select 1
      from public.duo_members dm
      where dm.user_id = p.user_id and dm.left_at is null
    )
    and exists (
      select 1
      from public.consents c
      where c.user_id = p.user_id
        and c.purpose = 'sensitive_preferences'
        and c.revoked_at is null
    )
  order by p.created_at
  limit 1;

  if first_user_id is null or second_user_id is null then
    raise exception 'duo_test_requires_two_onboarded_test_accounts';
  end if;

  execute 'set local role authenticated';
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', first_user_id::text, true);

  select public.create_duo_invite() into invitation;
  invite_token := invitation ->> 'invite_token';
  if invite_token is null or length(invite_token) <> 64 then
    raise exception 'invite_token_was_not_generated';
  end if;

  select public.get_my_duo() into first_status;
  if first_status ->> 'state' <> 'waiting_for_invite' then
    raise exception 'creator_is_not_waiting_for_invite';
  end if;

  begin
    perform public.accept_duo_invite(invite_token);
    raise exception 'self_acceptance_was_allowed';
  exception when others then
    if sqlerrm <> 'self_acceptance_not_allowed' then
      raise;
    end if;
  end;

  perform set_config('request.jwt.claim.sub', second_user_id::text, true);
  perform public.accept_duo_invite(invite_token);
  select public.get_my_duo() into second_status;
  if second_status ->> 'state' <> 'active' then
    raise exception 'recipient_did_not_receive_active_duo';
  end if;

  perform set_config('request.jwt.claim.sub', first_user_id::text, true);
  select public.get_my_duo() into first_status;
  if first_status ->> 'state' <> 'active' then
    raise exception 'creator_did_not_receive_active_duo';
  end if;

  begin
    perform public.accept_duo_invite(invite_token);
    raise exception 'reused_invite_was_allowed';
  exception when others then
    if sqlerrm not in ('invalid_invite', 'already_in_active_duo') then
      raise;
    end if;
  end;

  perform public.leave_duo();
  select public.get_my_duo() into first_status;
  if first_status ->> 'state' <> 'no_duo' then
    raise exception 'creator_can_still_access_ended_duo';
  end if;

  perform set_config('request.jwt.claim.sub', second_user_id::text, true);
  select public.get_my_duo() into second_status;
  if second_status ->> 'state' <> 'no_duo' then
    raise exception 'other_member_can_still_access_ended_duo';
  end if;

  execute 'reset role';
end;
$$;

select 'PASS: duo tables are RPC-only and anonymous access is blocked' as result;

rollback;
