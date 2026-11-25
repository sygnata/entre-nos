import 'package:flutter_test/flutter_test.dart';

import 'package:entrenos/app/app.dart';

void main() {
  testWidgets('renders the bootstrap screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EntreNosApp());

    expect(find.text('EntreNós'), findsOneWidget);
    expect(find.text('Em preparação'), findsOneWidget);
  });
}
