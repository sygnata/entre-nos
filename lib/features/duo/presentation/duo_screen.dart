import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_card.dart';
import '../../auth/application/auth_providers.dart';
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
      if (mounted) ref.invalidate(duoStatusProvider);
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_duoErrorMessage(error.message))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível concluir esta ação. Tente novamente.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _duoErrorMessage(String message) => switch (message) {
    'onboarding_incomplete' =>
      'Conclua a confirmação de idade e o consentimento antes de vincular.',
    'invalid_invite' || 'self_acceptance_not_allowed' =>
      'Não foi possível usar este convite. Confira se o código está completo, válido e foi criado por outra conta.',
    'already_in_active_duo' => 'Esta conta já participa de uma dupla.',
    _ => 'Não foi possível concluir esta ação. Tente novamente.',
  };

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
    if (token.isNotEmpty) {
      await _run(() => ref.read(duoActionsProvider).acceptInvite(token));
    }
  }

  Future<void> _cancelInvite() async {
    final inviteId = widget.status.pendingInviteId;
    if (inviteId != null) {
      await _run(() => ref.read(duoActionsProvider).cancelInvite(inviteId));
    }
  }

  Future<void> _leaveDuo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
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

  Future<void> _signOut() async {
    try {
      await ref.read(authRepositoryProvider)?.signOut();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível sair da conta. Tente novamente.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status.state == DuoState.active) {
      return _ActiveDuoScreen(
        isSubmitting: _isSubmitting,
        onLeave: _leaveDuo,
        onSignOut: _signOut,
      );
    }

    final tokens = context.entreNosTokens;
    return AppPage(
      title: 'Sua dupla privada',
      actions: [
        IconButton(
          onPressed: _isSubmitting ? null : _signOut,
          tooltip: 'Sair da conta',
          icon: const Icon(Icons.logout),
        ),
      ],
      children: [
        Text(
          'Construa este espaço a duas pessoas.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: tokens.sectionGap),
        AppSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Convide uma pessoa adulta para formar uma dupla privada. O convite não revela seu e-mail.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: tokens.sectionGap),
              FilledButton(
                onPressed: _isSubmitting ? null : _createInvite,
                child: const Text('Gerar código de convite'),
              ),
              if (widget.status.pendingInviteId != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _isSubmitting ? null : _cancelInvite,
                  child: const Text('Cancelar convite atual'),
                ),
              ],
              if (_createdInviteToken != null) ...[
                SizedBox(height: tokens.sectionGap),
                const Text(
                  'Compartilhe este código somente com a pessoa convidada:',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.subtleSurface,
                    borderRadius: tokens.cardRadius,
                  ),
                  child: SelectableText(
                    _createdInviteToken!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (_createdInviteExpiresAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Válido até ${_formatInviteExpiration(_createdInviteExpiresAt!)}.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: _createdInviteToken!),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código copiado.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copiar código'),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: tokens.sectionGap),
        Text(
          'Recebeu um código?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _inviteController,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
            LengthLimitingTextInputFormatter(64),
          ],
          decoration: const InputDecoration(labelText: 'Código de convite'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _isSubmitting ? null : _acceptInvite,
          child: const Text('Aceitar convite'),
        ),
      ],
    );
  }

  String _formatInviteExpiration(DateTime value) {
    final local = value.toLocal();
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(local.day)}/${twoDigits(local.month)}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }
}

class _ActiveDuoScreen extends StatelessWidget {
  const _ActiveDuoScreen({
    required this.isSubmitting,
    required this.onLeave,
    required this.onSignOut,
  });

  final bool isSubmitting;
  final VoidCallback onLeave;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final tokens = context.entreNosTokens;
    return AppPage(
      title: 'Sua dupla privada',
      actions: [
        IconButton(
          onPressed: isSubmitting ? null : onSignOut,
          tooltip: 'Sair da conta',
          icon: const Icon(Icons.logout),
        ),
      ],
      children: [
        Text(
          'Dupla formada.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: tokens.sectionGap),
        AppSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: tokens.success,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Dupla formada com privacidade.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'As perguntas e os matches serão disponibilizados nas próximas etapas.',
              ),
            ],
          ),
        ),
        SizedBox(height: tokens.sectionGap * 2),
        OutlinedButton(
          onPressed: isSubmitting ? null : onLeave,
          child: const Text('Encerrar dupla'),
        ),
      ],
    );
  }
}
