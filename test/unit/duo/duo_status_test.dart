import 'package:flutter_test/flutter_test.dart';

import 'package:entrenos/features/duo/domain/entities/duo_status.dart';

void main() {
  test('maps active duo status without member data', () {
    final status = DuoStatus.fromRpc({
      'state': 'active',
      'duo_id': 'duo-id',
    });

    expect(status.state, DuoState.active);
    expect(status.duoId, 'duo-id');
    expect(status.pendingInviteId, isNull);
  });

  test('maps an unknown RPC state to no duo', () {
    final status = DuoStatus.fromRpc({'state': 'unexpected'});

    expect(status.state, DuoState.noDuo);
    expect(status.duoId, isNull);
  });

  test('maps invite expiry from RPC status', () {
    final status = DuoStatus.fromRpc({
      'state': 'waiting_for_invite',
      'pending_invite_id': 'invite-id',
      'pending_invite_expires_at': '2026-11-28T12:00:00Z',
    });

    expect(status.state, DuoState.waitingForInvite);
    expect(status.pendingInviteId, 'invite-id');
    expect(status.pendingInviteExpiresAt, DateTime.utc(2026, 11, 28, 12));
  });
}
