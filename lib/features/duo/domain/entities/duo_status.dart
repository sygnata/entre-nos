enum DuoState { noDuo, waitingForInvite, active }

class DuoStatus {
  const DuoStatus({
    required this.state,
    this.duoId,
    this.pendingInviteId,
    this.pendingInviteExpiresAt,
  });

  final DuoState state;
  final String? duoId;
  final String? pendingInviteId;
  final DateTime? pendingInviteExpiresAt;

  factory DuoStatus.fromRpc(Map<String, dynamic> value) {
    final state = switch (value['state']) {
      'waiting_for_invite' => DuoState.waitingForInvite,
      'active' => DuoState.active,
      _ => DuoState.noDuo,
    };
    final expiresAt = value['pending_invite_expires_at'] as String?;
    return DuoStatus(
      state: state,
      duoId: value['duo_id'] as String?,
      pendingInviteId: value['pending_invite_id'] as String?,
      pendingInviteExpiresAt:
          expiresAt == null ? null : DateTime.tryParse(expiresAt),
    );
  }
}

class DuoInvite {
  const DuoInvite({
    required this.id,
    required this.token,
    required this.expiresAt,
  });

  final String id;
  final String token;
  final DateTime expiresAt;

  factory DuoInvite.fromRpc(Map<String, dynamic> value) => DuoInvite(
    id: value['invite_id'] as String,
    token: value['invite_token'] as String,
    expiresAt: DateTime.parse(value['invite_expires_at'] as String),
  );
}
