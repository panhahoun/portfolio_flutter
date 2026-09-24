import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_flutter/controllers/home_controller.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/sections/about_section.dart';
import 'package:portfolio_flutter/sections/contact_section.dart';
import 'package:portfolio_flutter/sections/education_section.dart';
import 'package:portfolio_flutter/sections/header.dart';
import 'package:portfolio_flutter/sections/home_section.dart';
import 'package:portfolio_flutter/sections/projects_section.dart';
import 'package:portfolio_flutter/sections/skills_section.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

class PortfolioHomePage extends GetView<HomeController> {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = controller;
    return Obx(() {
      SettingsController.to.code;
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: home.scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeSection(
                      key: home.sectionKeys[0],
                      onViewWork: () => home.scrollTo(3),
                      onContactMe: () => home.scrollTo(5),
                    ),
                    AboutSection(key: home.sectionKeys[1]),
                    SkillsSection(key: home.sectionKeys[2]),
                    ProjectsSection(key: home.sectionKeys[3]),
                    EducationSection(key: home.sectionKeys[4]),
                    ContactSection(key: home.sectionKeys[5]),
                    const _Footer(),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Header(),
            ),
          ],
        ),
      );
    });
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.footer,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          context.tr('footer.text'),
          textAlign: TextAlign.center,
          style: poppins(size: 13.5).copyWith(color: colors.muted),
        ),
      ),
    );
  }
}