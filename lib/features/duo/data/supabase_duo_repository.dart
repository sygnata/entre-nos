import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/entities/duo_status.dart';
import '../domain/repositories/duo_repository.dart';

class SupabaseDuoRepository implements DuoRepository {
  const SupabaseDuoRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> acceptInvite(String token) =>
      _client.rpc('accept_duo_invite', params: {'invite_token': token});

  @override
  Future<void> cancelInvite(String inviteId) => _client.rpc(
    'cancel_duo_invite',
    params: {'requested_invite_id': inviteId},
  );

  @override
  Future<DuoInvite> createInvite() async {
    final response = await _client.rpc('create_duo_invite');
    return DuoInvite.fromRpc(Map<String, dynamic>.from(response as Map));
  }

  @override
  Future<DuoStatus> getMyDuo() async {
    final response = await _client.rpc('get_my_duo');
    return DuoStatus.fromRpc(Map<String, dynamic>.from(response as Map));
  }

  @override
  Future<void> leaveDuo() => _client.rpc('leave_duo');
}
