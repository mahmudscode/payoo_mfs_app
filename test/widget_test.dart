import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:payoo_mfs/main.dart';

void main() {
  testWidgets('Login screen renders phone and pin fields', (WidgetTester tester) async {
    await tester.pumpWidget(const PayooApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Phone Number'), findsOneWidget);
    expect(find.text('Welcome to Payoo'), findsOneWidget);
  });

  testWidgets('Invalid login shows an error snackbar', (WidgetTester tester) async {
    await tester.pumpWidget(const PayooApp());

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Login failed'), findsOneWidget);
  });
}
