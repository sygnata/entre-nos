import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/duo_providers.dart';
import 'duo_screen.dart';

class DuoGate extends ConsumerWidget {
  const DuoGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duoStatus = ref.watch(duoStatusProvider);
    return duoStatus.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(duoStatusProvider),
            child: const Text('Tentar novamente'),
          ),
        ),
      ),
      data: (status) => DuoScreen(status: status),
    );
  }
}
