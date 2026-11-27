import '../entities/duo_status.dart';

abstract interface class DuoRepository {
  Future<DuoStatus> getMyDuo();
  Future<DuoInvite> createInvite();
  Future<void> acceptInvite(String token);
  Future<void> cancelInvite(String inviteId);
  Future<void> leaveDuo();
}
