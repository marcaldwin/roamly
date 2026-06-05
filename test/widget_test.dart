import 'package:flutter_test/flutter_test.dart';

import 'package:roamly/main.dart';

void main() {
  testWidgets('Roamly app renders Supabase setup message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RoamlyApp());

    expect(find.text('Roamly'), findsOneWidget);
    expect(
      find.text('Roamly connected to Supabase setup.'),
      findsOneWidget,
    );
  });
}
