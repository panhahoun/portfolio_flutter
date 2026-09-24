import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/app.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1280, 900);
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

  testWidgets('hover + toggle header icons does not assert', (tester) async {
    await pumpApp(tester);
    final settings = SettingsController.to;
    final darkBefore = settings.isDark.value;

    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kPrimaryButton,
    );
    final icon = faIcon(FontAwesomeIcons.moon);
    final center = tester.getCenter(icon);
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(center);
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.moveTo(center + const Offset(0, -10));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(center);
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.down(center);
    await tester.pump(const Duration(milliseconds: 30));
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(Offset(i.toDouble(), 1));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(settings.isDark.value, !darkBefore);
    expect(tester.takeException(), isNull, reason: 'no framework assertion');
    await gesture.removePointer();
    await tester.pumpWidget(const SizedBox());
  });
}