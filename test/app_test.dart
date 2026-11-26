import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:entrenos/app/app.dart';

void main() {
  testWidgets('renders the configuration message without Supabase values', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: EntreNosApp()));
    await tester.pump();

    expect(find.text('Configuração do ambiente necessária.'), findsOneWidget);
  });
}
