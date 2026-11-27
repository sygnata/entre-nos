import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_client_provider.dart';
import '../../auth/application/auth_providers.dart';
import '../data/supabase_onboarding_repository.dart';
import '../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : SupabaseOnboardingRepository(client);
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final session = ref.watch(authSessionProvider).when(
    data: (session) => session,
    loading: () => null,
    error: (_, _) => null,
  );
  if (session == null) {
    return false;
  }

  final repository = ref.watch(onboardingRepositoryProvider);
  if (repository == null) {
    return false;
  }

  return repository.hasCompletedRequiredConsents();
});
