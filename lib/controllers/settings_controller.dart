import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_flutter/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLocale { en, km }

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  final Rx<AppLocale> locale = AppLocale.en.obs;
  final RxBool isDark = false.obs;

  String get code => locale.value == AppLocale.en ? 'en' : 'km';
  String get langToggleLabel => locale.value == AppLocale.en ? 'KH' : 'EN';

  String t(String key) => locale.value == AppLocale.en
      ? Strings.en[key] ?? key
      : Strings.kh[key] ?? key;

  List<String> get typingWords =>
      locale.value == AppLocale.en ? Strings.typingEn : Strings.typingKh;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(load);
  }

  void toggleTheme() {
    isDark.toggle();
    _persist();
  }

  void toggleLocale() {
    locale.value =
        locale.value == AppLocale.en ? AppLocale.km : AppLocale.en;
    _persist();
  }

  void initWith({required bool dark, required String lang}) {
    isDark.value = dark;
    locale.value = lang == 'km' ? AppLocale.km : AppLocale.en;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      initWith(
        dark: prefs.getBool('theme_dark') ?? false,
        lang: prefs.getString('lang') ?? 'en',
      );
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme_dark', isDark.value);
      await prefs.setString('lang', code);
    } catch (_) {}
  }
}

extension L10nX on BuildContext {
  String tr(String key) => SettingsController.to.t(key);
}