import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final repository = ref.read(authRepositoryProvider);
    if (repository == null) {
      return;
    }

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
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível continuar.')),
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
    appBar: AppBar(title: const Text('EntreNós')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              _register ? 'Crie sua conta' : 'Entre na sua conta',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            TextButton(
              onPressed:
                  _loading
                      ? null
                      : () => setState(() => _register = !_register),
              child: Text(_register ? 'Já tenho uma conta' : 'Criar conta'),
            ),
          ],
        ),
      ),
    ),
  );
}
