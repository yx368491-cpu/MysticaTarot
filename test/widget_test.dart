import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build the app and trigger frames for async localization loading
    await tester.pumpWidget(const MysticaTarotApp());
    await tester.pump(); // Allow Localizations delegate to load

    // Verify the app title is displayed
    expect(find.text('MysticaTarot'), findsOneWidget);
  });
}
