import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/duo_providers.dart';
import '../domain/entities/duo_status.dart';

class DuoScreen extends ConsumerStatefulWidget {
  const DuoScreen({required this.status, super.key});

  final DuoStatus status;

  @override
  ConsumerState<DuoScreen> createState() => _DuoScreenState();
}

class _DuoScreenState extends ConsumerState<DuoScreen> {
  final _inviteController = TextEditingController();
  bool _isSubmitting = false;
  String? _createdInviteToken;
  DateTime? _createdInviteExpiresAt;

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _isSubmitting = true);
    try {
      await action();
      if (!mounted) {
        return;
      }
      ref.invalidate(duoStatusProvider);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível concluir esta ação. Tente novamente.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _createInvite() => _run(() async {
    final invite = await ref.read(duoActionsProvider).createInvite();
    if (mounted) {
      setState(() {
        _createdInviteToken = invite.token;
        _createdInviteExpiresAt = invite.expiresAt;
      });
    }
  });

  Future<void> _acceptInvite() async {
    final token = _inviteController.text.trim();
    if (token.isEmpty) {
      return;
    }
    await _run(() => ref.read(duoActionsProvider).acceptInvite(token));
  }

  Future<void> _cancelInvite() async {
    final inviteId = widget.status.pendingInviteId;
    if (inviteId == null) {
      return;
    }
    await _run(() => ref.read(duoActionsProvider).cancelInvite(inviteId));
  }

  Future<void> _leaveDuo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar dupla?'),
        content: const Text(
          'A saída encerra a dupla para as duas pessoas. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Encerrar dupla'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() => ref.read(duoActionsProvider).leaveDuo());
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    if (status.state == DuoState.active) {
      return _ActiveDuoScreen(
        isSubmitting: _isSubmitting,
        onLeave: _leaveDuo,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sua dupla privada')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Convide uma pessoa adulta para formar uma dupla privada. O convite não revela seu e-mail.',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSubmitting ? null : _createInvite,
            child: const Text('Gerar código de convite'),
          ),
          if (status.pendingInviteId != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isSubmitting ? null : _cancelInvite,
              child: const Text('Cancelar convite atual'),
            ),
          ],
          if (_createdInviteToken != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Compartilhe este código somente com a pessoa convidada:',
            ),
            const SizedBox(height: 8),
            SelectableText(_createdInviteToken!),
            if (_createdInviteExpiresAt != null)
              Text(
                'Válido até ${_createdInviteExpiresAt!.toLocal()}.',
              )
            else
              const SizedBox.shrink(),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: _createdInviteToken!),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado.')),
                  );
                }
              },
              child: const Text('Copiar código'),
            ),
          ],
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          const Text('Recebeu um código?'),
          TextField(
            controller: _inviteController,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              labelText: 'Código de convite',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _isSubmitting ? null : _acceptInvite,
            child: const Text('Aceitar convite'),
          ),
        ],
      ),
    );
  }
}

class _ActiveDuoScreen extends StatelessWidget {
  const _ActiveDuoScreen({required this.isSubmitting, required this.onLeave});

  final bool isSubmitting;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sua dupla privada')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dupla formada com privacidade.'),
          const SizedBox(height: 12),
          const Text(
            'As perguntas e os matches serão disponibilizados nas próximas etapas.',
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: isSubmitting ? null : onLeave,
            child: const Text('Encerrar dupla'),
          ),
        ],
      ),
    ),
  );
}
