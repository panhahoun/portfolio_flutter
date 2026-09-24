import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:portfolio_flutter/controllers/home_controller.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

const _navSections = [
  ('nav.home', 0),
  ('nav.about', 1),
  ('nav.skills', 2),
  ('nav.projects', 3),
  ('nav.education', 4),
  ('nav.contact', 5),
];

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _menuOpen = false;

  void _go(int index) {
    setState(() => _menuOpen = false);
    HomeController.to.scrollTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final home = HomeController.to;
    final colors = context.colors;

    return Obx(() {
      final scrolled = home.scrolled.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: scrolled ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: scrolled ? colors.headerScrim : Colors.transparent,
          boxShadow: scrolled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: scrolled
                ? ImageFilter.blur(sigmaX: 12, sigmaY: 12)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderRow(menuOpen: _menuOpen, onToggle: () {
                  setState(() => _menuOpen = !_menuOpen);
                }, onGo: _go),
                if (!home.isDesktop) ...[
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: _menuOpen
                        ? _MobilePanel(onGo: _go)
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.menuOpen,
    required this.onToggle,
    required this.onGo,
  });

  final bool menuOpen;
  final VoidCallback onToggle;
  final void Function(int) onGo;

  @override
  Widget build(BuildContext context) {
    final home = HomeController.to;
    final settings = SettingsController.to;
    final isDesktop = home.isDesktop;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Logo(onTap: () => onGo(0)),
        if (isDesktop)
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (key, index) in _navSections) _NavLink(
                  label: settings.t(key),
                  active: index == home.activeIndex.value,
                  onTap: () => onGo(index),
                ),
              ],
            ),
          ),
        Obx(() {
          final current = SettingsController.to;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleIcon(
                tooltip: current.langToggleLabel,
                label: current.langToggleLabel,
                onTap: current.toggleLocale,
              ),
              const SizedBox(width: 10),
              _CircleIcon(
                tooltip: current.isDark.value ? 'Light mode' : 'Dark mode',
                icon: current.isDark.value
                    ? FontAwesomeIcons.sun
                    : FontAwesomeIcons.moon,
                onTap: current.toggleTheme,
              ),
              if (!isDesktop) ...[
                const SizedBox(width: 10),
                _CircleIcon(
                  tooltip: 'Menu',
                  icon: FontAwesomeIcons.bars,
                  defaultColor: menuOpen ? Colors.white : null,
                  filled: menuOpen,
                  onTap: onToggle,
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'Panha',
                  style: poppins(size: 30, weight: FontWeight.w800),
                ),
                TextSpan(
                  text: '.',
                  style: poppins(size: 30, weight: FontWeight.w800)
                      .copyWith(color: colors.text),
                ),
              ]),
              style: const TextStyle(color: kAccent),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CardHover(
      builder: (context, hovering) {
        return GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: active || hovering ? kAccent : colors.text,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: active ? label.length * 7.0 + 10 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.onTap,
    required this.tooltip,
    this.icon,
    this.label,
    this.filled = false,
    this.defaultColor,
  });

  final VoidCallback onTap;
  final String tooltip;
  final FaIconData? icon;
  final String? label;
  final bool filled;
  final Color? defaultColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: tooltip,
      button: true,
      child: CardHover(
        onTap: onTap,
        builder: (context, hovering) {
          final filledState = filled || hovering;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filledState ? kAccent : Colors.transparent,
              border: Border.all(color: kAccent, width: 2),
              boxShadow: hovering
                  ? [BoxShadow(color: kAccentGlow(), blurRadius: 20)]
                  : null,
            ),
            alignment: Alignment.center,
            child: icon != null
                ? FaIcon(
                    icon,
                    size: 17,
                    color: filledState
                        ? Colors.white
                        : (defaultColor ?? colors.text),
                  )
                : Text(
                    label ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: filledState
                          ? Colors.white
                          : (defaultColor ?? colors.text),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _MobilePanel extends StatelessWidget {
  const _MobilePanel({required this.onGo});
  final void Function(int) onGo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;
    final home = HomeController.to;
    return Obx(() {
      final active = home.activeIndex.value;
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            left: BorderSide(color: kAccent, width: 3),
            bottom: BorderSide(color: kAccent, width: 3),
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 30,
              offset: const Offset(-8, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (key, index) in _navSections)
              CardHover(
                onTap: () => onGo(index),
                cursor: SystemMouseCursors.basic,
                builder: (context, hovering) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: index == active ? 12 : 0,
                      vertical: index == active ? 3 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: index == active
                          ? kAccent.withValues(alpha: .12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      settings.t(key),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: index == active || hovering
                            ? kAccent
                            : colors.text,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}