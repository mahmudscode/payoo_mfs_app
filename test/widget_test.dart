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

  group('desktop layout', () {
    void useDesktopViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> login(WidgetTester tester) async {
      await tester.enterText(find.widgetWithText(TextField, 'Phone Number'), '01611111111');
      await tester.enterText(find.widgetWithText(TextField, 'Pin'), '1234');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
    }

    testWidgets('login shows the split brand panel', (WidgetTester tester) async {
      useDesktopViewport(tester);
      await tester.pumpWidget(const PayooApp());

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Easy and convenient financial services, all in one place.'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('home shows sidebar dashboard and opens forms as dialogs', (WidgetTester tester) async {
      useDesktopViewport(tester);
      await tester.pumpWidget(const PayooApp());
      await login(tester);

      expect(find.text('Dashboard'), findsNWidgets(2)); // sidebar item + top bar
      expect(find.text('\$45,000.00'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);

      await tester.tap(find.text('Get Bonus').first);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Enter coupon'), 'PAYOO500');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Bonus'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
      expect(find.text('\$45,500.00'), findsOneWidget);
    });

    testWidgets('dialog can be closed with the close button', (WidgetTester tester) async {
      useDesktopViewport(tester);
      await tester.pumpWidget(const PayooApp());
      await login(tester);

      await tester.tap(find.text('Pay Bill').first);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}
