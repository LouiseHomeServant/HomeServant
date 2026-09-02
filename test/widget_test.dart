import 'package:flutter_test/flutter_test.dart';

import 'package:homeservant/app.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeServantApp());
    await tester.pump();

    expect(find.text('EXPLORE'), findsOneWidget);
  });
}
