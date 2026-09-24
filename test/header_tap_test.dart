import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/app.dart';
import 'package:portfolio_flutter/controllers/home_controller.dart';
import 'package:portfolio_flutter/sections/header.dart';
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
  Finder faIcon(FaIconData data) => find.byWidgetPredicate(
        (w) => w is FaIcon && w.icon?.codePoint == data.codePoint,
      );

  testWidgets('header nav click scrolls', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final home = HomeController.to;
    final aboutLink = find.descendant(
      of: find.byType(Header),
      matching: find.text('About'),
    );
    expect(aboutLink, findsOneWidget);
    await tester.tap(aboutLink);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(home.scroll.offset, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('mobile hamburger opens panel and nav works', (tester) async {
    await pumpPortfolio(tester, size: const Size(390, 844));
    final home = HomeController.to;
    expect(faIcon(FontAwesomeIcons.bars), findsOneWidget);
    await tester.tap(faIcon(FontAwesomeIcons.bars));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('About'), findsWidgets);
    await tester.tap(find.text('Skills').last);
    await tester.pump(const Duration(milliseconds: 100));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(home.scroll.offset, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('theme toggle works', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final settings = SettingsController.to;
    final wasDark = settings.isDark.value;
    await tester.tap(faIcon(FontAwesomeIcons.moon));
    await tester.pump(const Duration(milliseconds: 300));
    expect(settings.isDark.value, !wasDark);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('language toggle works', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final settings = SettingsController.to;
    final before = settings.locale.value;
    expect(find.text('Who I Am'), findsWidgets);
    await tester.tap(find.text('KH'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(settings.locale.value,
        before == AppLocale.en ? AppLocale.km : AppLocale.en);
    expect(find.text('Who I Am'), findsNothing);
    expect(find.text('ប្រវត្តិរូបសង្ខេប'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('header contact nav scrolls to bottom', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    SettingsController.to.initWith(dark: false, lang: 'en');
    await tester.pump();
    final home = HomeController.to;
    final contactLink = find.descendant(
      of: find.byType(Header),
      matching: find.text('Contact'),
    );
    expect(contactLink, findsOneWidget);
    await tester.tap(contactLink);
    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(home.scroll.offset, greaterThan(0));
    final context = home.sectionKeys[5].currentContext;
    final ro = context?.findRenderObject();
    final contactTop = ro is RenderBox ? ro.localToGlobal(Offset.zero).dy : null;
    expect(contactTop, lessThan(540));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('header contact nav lands contact near top', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    SettingsController.to.initWith(dark: false, lang: 'en');
    await tester.pump();
    final home = HomeController.to;
    final contactLink = find.descendant(
      of: find.byType(Header),
      matching: find.text('Contact'),
    );
    await tester.tap(contactLink);
    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final context = home.sectionKeys[5].currentContext;
    final ro = context?.findRenderObject();
    final contactTop = ro is RenderBox ? ro.localToGlobal(Offset.zero).dy : null;
    expect(contactTop, lessThan(540));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('direct scrollTo works', (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final home = HomeController.to;
    await tester.pump(const Duration(milliseconds: 100));
    home.scrollTo(1);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(home.scroll.offset, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('active nav underline not stuck on contact at top',
      (tester) async {
    await pumpPortfolio(tester, size: const Size(1280, 900));
    final home = HomeController.to;
    await tester.pump(const Duration(milliseconds: 300));
    expect(home.activeIndex.value, 0,
        reason: 'at page top, Home (not Contact) must be active');
    expect(home.scroll.offset, 0);
    await tester.pumpWidget(const SizedBox());
  });
}
