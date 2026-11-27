-- RLS policies do not replace PostgreSQL table privileges. Grant only the
-- read access required for the authenticated user's own onboarding state.
grant select on table public.profiles to authenticated;
grant select on table public.consents to authenticated;
