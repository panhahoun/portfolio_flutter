import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_flutter/bindings/app_bindings.dart';
import 'package:portfolio_flutter/bindings/home_bindings.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/views/home_page.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  @override
  void initState() {
    super.initState();
    AppBindings().dependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = SettingsController.to;
      settings.code;
      return GetMaterialApp(
        title: 'Houn Panha — Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: settings.isDark.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => const PortfolioHomePage(),
            binding: HomeBindings(),
          ),
        ],
      );
    });
  }
}