import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jm_hockey/main.dart';

void main() {
  testWidgets('shows the login screen first', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in to your JM Hockey account'), findsOneWidget);
  });

  testWidgets('shows the dashboard after login', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), 'admin@jmhockey.com');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Admin control center'), findsOneWidget);
  });
}
