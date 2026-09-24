import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kAccent = Color(0xFF1E90FF);
const Color kAccentStrong = Color(0xFF0b74d5);
const Color kAccentLight = Color(0xFF4DA6FF);

Color kAccentGlow() => kAccent.withValues(alpha: 0.35);

const Color kLightBg = Color(0xFFF6F8FB);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightText = Color(0xFF0F172A);
const Color kLightMuted = Color(0xFF5B6B7C);
const Color kLightFooter = Color(0xFF0A0D14);

const Color kDarkBg = Color(0xFF05070C);
const Color kDarkSurface = Color(0xFF0D1420);
const Color kDarkText = Color(0xFFF0F4F9);
const Color kDarkMuted = Color(0xFF8FA1B5);
const Color kDarkFooter = Color(0xFF030408);

class PortfolioColors {
  PortfolioColors._({
    required this.bg,
    required this.surface,
    required this.text,
    required this.muted,
    required this.footer,
    required this.cardBorder,
    required this.headerScrim,
  });

  final Color bg;
  final Color surface;
  final Color text;
  final Color muted;
  final Color footer;
  final Color cardBorder;
  final Color headerScrim;

  static PortfolioColors light() => PortfolioColors._(
        bg: kLightBg,
        surface: kLightSurface,
        text: kLightText,
        muted: kLightMuted,
        footer: kLightFooter,
        cardBorder: kAccent.withValues(alpha: 0.18),
        headerScrim: kLightBg.withValues(alpha: 0.82),
      );

  static PortfolioColors dark() => PortfolioColors._(
        bg: kDarkBg,
        surface: kDarkSurface,
        text: kDarkText,
        muted: kDarkMuted,
        footer: kDarkFooter,
        cardBorder: kAccent.withValues(alpha: 0.25),
        headerScrim: kDarkBg.withValues(alpha: 0.82),
      );
}

extension PortfolioColorsX on BuildContext {
  PortfolioColors get colors {
    final scheme = Theme.of(this).colorScheme;
    return scheme.brightness == Brightness.dark
        ? PortfolioColors.dark()
        : PortfolioColors.light();
  }
}

const Color kContactGradientEnd = Color(0xFF4DA6FF);

LinearGradient contactGradient() => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [kAccentStrong, kAccent, kContactGradientEnd],
    );

ThemeData buildTheme(Brightness brightness) {
  final base = ThemeData(brightness: brightness, useMaterial3: true);
  final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: kAccent,
    brightness: brightness,
    primary: kAccent,
    onPrimary: Colors.white,
    surface: isDark ? kDarkSurface : kLightSurface,
    onSurface: isDark ? kDarkText : kLightText,
    error: const Color(0xFFB3261E),
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: isDark ? kDarkBg : kLightBg,
    textTheme: textTheme,
    dividerColor: Colors.transparent,
    splashFactory: InkSparkle.splashFactory,
  );
}