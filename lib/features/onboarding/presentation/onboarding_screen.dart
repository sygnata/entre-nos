import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../application/onboarding_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _adult = false;
  bool _consent = false;
  bool _loading = false;

  Future<void> _continue() async {
    if (!_adult || !_consent) {
      return;
    }
    final repository = ref.read(onboardingRepositoryProvider);
    if (repository == null) {
      return;
    }

    setState(() => _loading = true);
    try {
      await repository.confirmAdulthood();
      await repository.grantSensitivePreferencesConsent('1.0');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consentimento registrado.')),
        );
        ref.invalidate(onboardingCompletedProvider);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível registrar suas escolhas.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Antes de começar'),
      actions: [
        IconButton(
          onPressed: () => ref.read(authRepositoryProvider)?.signOut(),
          tooltip: 'Sair da conta',
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Privacidade e consentimento',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Suas respostas podem revelar informações sensíveis. Elas são privadas e você poderá revogar o consentimento depois.',
          ),
          CheckboxListTile(
            value: _adult,
            onChanged: (value) => setState(() => _adult = value ?? false),
            title: const Text('Confirmo que tenho 18 anos ou mais.'),
          ),
          CheckboxListTile(
            value: _consent,
            onChanged: (value) => setState(() => _consent = value ?? false),
            title: const Text(
              'Concordo especificamente com o tratamento das minhas respostas para disponibilizar os matches.',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading || !_adult || !_consent ? null : _continue,
            child: Text(_loading ? 'Salvando...' : 'Continuar'),
          ),
        ],
      ),
    ),
  );
}
