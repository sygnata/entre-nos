abstract interface class OnboardingRepository {
  Future<void> confirmAdulthood();
  Future<void> grantSensitivePreferencesConsent(String policyVersion);
  Future<bool> hasCompletedRequiredConsents();
}
