import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/repositories/onboarding_repository.dart';

class SupabaseOnboardingRepository implements OnboardingRepository {
  const SupabaseOnboardingRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<void> confirmAdulthood() => _client.rpc('confirm_adulthood');

  @override
  Future<void> grantSensitivePreferencesConsent(String policyVersion) =>
      _client.rpc(
        'grant_sensitive_preferences_consent',
        params: {'requested_policy_version': policyVersion},
      );

  @override
  Future<bool> hasCompletedRequiredConsents() async {
    final profile =
        await _client
            .from('profiles')
            .select('adult_confirmed_at')
            .maybeSingle();
    final consents = await _client
        .from('consents')
        .select('id')
        .eq('purpose', 'sensitive_preferences')
        .isFilter('revoked_at', null)
        .limit(1);

    return profile?['adult_confirmed_at'] != null && consents.isNotEmpty;
  }
}
