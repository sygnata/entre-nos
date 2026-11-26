import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_client_provider.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : SupabaseAuthRepository(client);
});
