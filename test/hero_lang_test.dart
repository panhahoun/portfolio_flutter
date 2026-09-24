import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter/app.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpPortfolio(WidgetTester tester, {Size? size}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size ?? const Size(1280, 900);
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const PortfolioApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 900));
}

void main() {
  testWidgets('home hero switches to Khmer on language toggle',
      (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final settings = SettingsController.to;
    expect(find.text('Who I Am'), findsWidgets);
    expect(find.textContaining('Hello, I'), findsOneWidget);

    await tester.tap(find.text('KH'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(settings.locale.value, AppLocale.km);
    expect(find.text('Who I Am'), findsNothing);
    expect(find.textContaining('សួស្តី!'), findsOneWidget,
        reason: 'hero greeting must be Khmer after toggle');
    expect(find.textContaining('ហួន បញ្ញា'), findsOneWidget);
    expect(find.text('អ្នកអភិវឌ្ឍន៍ FLUTTER FULL-STACK'), findsOneWidget);

    await tester.tap(find.text('EN'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Hello, I'), findsOneWidget);
    expect(settings.locale.value, AppLocale.en);
    await tester.pumpWidget(const SizedBox());
  });
}