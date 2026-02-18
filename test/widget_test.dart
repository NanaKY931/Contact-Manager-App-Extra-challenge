import 'package:flutter_test/flutter_test.dart';
import 'package:challenger/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactManagerApp());
    expect(find.text('My Contacts'), findsOneWidget);
  });
}
