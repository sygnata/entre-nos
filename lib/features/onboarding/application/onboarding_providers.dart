import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/supabase_client_provider.dart';
import '../data/supabase_onboarding_repository.dart';
import '../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : SupabaseOnboardingRepository(client);
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  if (repository == null) {
    return false;
  }

  return repository.hasCompletedRequiredConsents();
});
