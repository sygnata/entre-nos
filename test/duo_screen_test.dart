import 'package:entrenos/features/auth/application/auth_providers.dart';
import 'package:entrenos/features/auth/domain/repositories/auth_repository.dart';
import 'package:entrenos/features/duo/domain/entities/duo_status.dart';
import 'package:entrenos/features/duo/presentation/duo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('allows signing out from the private duo screen', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: DuoScreen(status: DuoStatus(state: DuoState.noDuo)),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Sair da conta'));
    await tester.pump();

    expect(repository.didSignOut, isTrue);
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool didSignOut = false;

  @override
  Future<bool> hasValidSession() async => true;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {
    didSignOut = true;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}
