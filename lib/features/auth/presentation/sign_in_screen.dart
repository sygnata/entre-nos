import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_card.dart';
import '../application/auth_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final repository = ref.read(authRepositoryProvider);
    if (repository == null) return;

    setState(() => _loading = true);
    try {
      if (_register) {
        await repository.signUp(
          email: _email.text.trim(),
          password: _password.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Confira seu e-mail para confirmar a conta.'),
            ),
          );
        }
      } else {
        await repository.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_authErrorMessage(error))));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível continuar.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _authErrorMessage(AuthException error) {
    if (error.statusCode == '429' || error.message.contains('rate limit')) {
      return 'Limite de tentativas atingido. Aguarde antes de tentar novamente.';
    }
    if (_register) {
      return 'Não foi possível enviar a confirmação. Verifique o limite de e-mails e tente mais tarde.';
    }
    return 'Não foi possível entrar. Confira seu e-mail e senha.';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.entreNosTokens;
    return Form(
      key: _formKey,
      child: AppPage(
        title: 'EntreNós',
        children: [
          Text(
            _register ? 'Crie sua conta' : 'Entre na sua conta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: tokens.sectionGap),
          AppSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _register
                      ? 'Use seu e-mail para criar uma identidade privada.'
                      : 'Acesse sua identidade privada para continuar.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: tokens.sectionGap),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator:
                      (value) =>
                          value != null && value.contains('@')
                              ? null
                              : 'Informe um e-mail válido.',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(labelText: 'Senha'),
                  validator:
                      (value) =>
                          value != null && value.length >= 8
                              ? null
                              : 'A senha deve ter pelo menos 8 caracteres.',
                ),
                SizedBox(height: tokens.sectionGap),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(
                    _loading
                        ? 'Aguarde...'
                        : _register
                        ? 'Cadastrar'
                        : 'Entrar',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed:
                _loading ? null : () => setState(() => _register = !_register),
            child: Text(_register ? 'Já tenho uma conta' : 'Criar conta'),
          ),
        ],
      ),
    );
  }
}
