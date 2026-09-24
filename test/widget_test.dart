import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/strings.dart';

void main() {
  test('settings controller defaults', () {
    final settings = SettingsController();
    expect(settings.locale.value, AppLocale.en);
    expect(settings.isDark.value, isFalse);
    expect(settings.t('nav.home'), 'Home');
  });

  test('locale toggle flips language', () {
    final settings = SettingsController();
    settings.toggleLocale();
    expect(settings.locale.value, AppLocale.km);
    expect(settings.t('nav.home'), Strings.kh['nav.home']);
  });
}