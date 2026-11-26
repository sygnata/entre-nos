import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../onboarding/application/onboarding_providers.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../application/auth_providers.dart';
import 'sign_in_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConfig.hasSupabaseConfiguration) {
      return const _ConfigurationRequiredScreen();
    }
    final session = ref.watch(authSessionProvider);
    return session.when(
      loading: () => const _LoadingScreen(),
      error: (_, __) => const _RecoverableErrorScreen(),
      data: (value) {
        if (value == null) {
          return const SignInScreen();
        }
        if (value.user.emailConfirmedAt == null) {
          return const _EmailConfirmationRequired();
        }
        final onboarding = ref.watch(onboardingCompletedProvider);
        return onboarding.when(
          loading: () => const _LoadingScreen(),
          error: (_, __) => const _RecoverableErrorScreen(),
          data:
              (completed) =>
                  completed
                      ? const _OnboardingCompleteScreen()
                      : const OnboardingScreen(),
        );
      },
    );
  }
}

class _ConfigurationRequiredScreen extends StatelessWidget {
  const _ConfigurationRequiredScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Configuração do ambiente necessária.'),
      ),
    ),
  );
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _RecoverableErrorScreen extends StatelessWidget {
  const _RecoverableErrorScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Não foi possível carregar sua sessão. Tente novamente.'),
      ),
    ),
  );
}

class _EmailConfirmationRequired extends ConsumerWidget {
  const _EmailConfirmationRequired();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Confirme seu e-mail')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enviamos uma mensagem para confirmar seu endereço de e-mail.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.read(authRepositoryProvider)?.signOut(),
            child: const Text('Sair'),
          ),
        ],
      ),
    ),
  );
}

class _OnboardingCompleteScreen extends StatelessWidget {
  const _OnboardingCompleteScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('EntreNós')),
    body: const Padding(
      padding: EdgeInsets.all(24),
      child: Text('Conta pronta. A vinculação de casal será a próxima etapa.'),
    ),
  );
}
