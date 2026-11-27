import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/supabase_client_provider.dart';
import '../data/supabase_duo_repository.dart';
import '../domain/entities/duo_status.dart';
import '../domain/repositories/duo_repository.dart';

final duoRepositoryProvider = Provider<DuoRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : SupabaseDuoRepository(client);
});

final duoStatusProvider = FutureProvider<DuoStatus>((ref) async {
  final repository = ref.watch(duoRepositoryProvider);
  return repository?.getMyDuo() ?? const DuoStatus(state: DuoState.noDuo);
});

final duoActionsProvider = Provider<DuoActions>((ref) {
  final repository = ref.watch(duoRepositoryProvider);
  if (repository == null) {
    throw StateError('Supabase configuration is required.');
  }
  return DuoActions(repository);
});

class DuoActions {
  const DuoActions(this._repository);

  final DuoRepository _repository;

  Future<DuoInvite> createInvite() => _repository.createInvite();
  Future<void> acceptInvite(String token) => _repository.acceptInvite(token);
  Future<void> cancelInvite(String inviteId) =>
      _repository.cancelInvite(inviteId);
  Future<void> leaveDuo() => _repository.leaveDuo();
}
