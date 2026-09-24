import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpPortfolio(WidgetTester tester, {Size? size}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size ?? const Size(1280, 900);
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const PortfolioApp());
  // let SharedPreferences future resolve and first frame settle
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 900));
}

void main() {
  testWidgets('desktop layout renders without exceptions', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Panha'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('mobile layout renders without exceptions', (tester) async {
    await pumpPortfolio(tester, size: const Size(390, 844));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Panha'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });
}