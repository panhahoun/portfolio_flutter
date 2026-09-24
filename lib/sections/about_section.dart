import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

const _infoItems = [
  (key: 'info.location', icon: FontAwesomeIcons.mapLocationDot, val: 'info.locationVal'),
  (key: 'info.focus', icon: FontAwesomeIcons.code, val: 'info.focusVal'),
  (key: 'info.education', icon: FontAwesomeIcons.graduationCap, val: 'info.educationVal'),
  (key: 'info.email', icon: FontAwesomeIcons.solidEnvelope, val: 'info.emailVal'),
];

List<InlineSpan> parseAboutParagraph(
  BuildContext context,
  String text,
  TextStyle base,
) {
  final spans = <InlineSpan>[];
  final parts = text.split(RegExp(r'(<strong>|</strong>)'));
  bool bold = false;
  for (final part in parts) {
    if (part.isEmpty) continue;
    if (part == '<strong>') {
      bold = true;
      continue;
    }
    if (part == '</strong>') {
      bold = false;
      continue;
    }
    spans.add(TextSpan(
      text: part,
      style: bold
          ? base.copyWith(color: kAccent, fontWeight: FontWeight.w700)
          : base,
    ));
  }
  return spans;
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;
    final isDesktop = MediaQuery.sizeOf(context).width > 995;
    final padH = (MediaQuery.sizeOf(context).width * 0.09).clamp(24.0, 140.0);

    final paragraphs = <String>[
      settings.t('about.p1'),
      settings.t('about.p2'),
      settings.t('about.p3'),
    ];

    final textStyle = poppins(size: 16, height: 1.8)
        .copyWith(color: colors.muted);

    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 100, padH, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: SectionLabel(
              text: settings.t('nav.about'),
            ),
          ),
          const SizedBox(height: 14),
          RevealOnScroll(
            child: SectionTitle(text: settings.t('about.title')),
          ),
          const SizedBox(height: 30),
          if (isDesktop)
            _DesktopAbout(
              paragraphs: paragraphs,
              textStyle: textStyle,
              settings: settings,
              colors: colors,
            )
          else
            _MobileAbout(
              paragraphs: paragraphs,
              textStyle: textStyle,
              settings: settings,
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _DesktopAbout extends StatelessWidget {
  const _DesktopAbout({
    required this.paragraphs,
    required this.textStyle,
    required this.settings,
    required this.colors,
  });

  final List<String> paragraphs;
  final TextStyle textStyle;
  final SettingsController settings;
  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _TextColumn(
            paragraphs: paragraphs,
            textStyle: textStyle,
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 4,
          child: _InfoCards(settings: settings),
        ),
      ],
    );
  }
}

class _MobileAbout extends StatelessWidget {
  const _MobileAbout({
    required this.paragraphs,
    required this.textStyle,
    required this.settings,
    required this.colors,
  });

  final List<String> paragraphs;
  final TextStyle textStyle;
  final SettingsController settings;
  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextColumn(paragraphs: paragraphs, textStyle: textStyle),
        const SizedBox(height: 30),
        _InfoCards(settings: settings),
      ],
    );
  }
}

class _TextColumn extends StatelessWidget {
  const _TextColumn({required this.paragraphs, required this.textStyle});

  final List<String> paragraphs;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          RevealOnScroll(
            child: Text.rich(
              TextSpan(children: parseAboutParagraph(
                context,
                paragraphs[i],
                textStyle,
              )),
              textAlign: TextAlign.justify,
            ),
          ),
          if (i < paragraphs.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _InfoCards extends StatelessWidget {
  const _InfoCards({required this.settings});
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        for (final item in _infoItems)
          RevealOnScroll(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _InfoCard(
                title: settings.t(item.key),
                icon: item.icon,
                value: settings.t(item.val),
                colors: colors,
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.colors,
  });

  final String title;
  final FaIconData icon;
  final String? value;
  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return CardHover(
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          transform: hovering
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hovering ? kAccent : colors.cardBorder,
            ),
            boxShadow: hovering
                ? [BoxShadow(color: kAccentGlow(), blurRadius: 30, offset: const Offset(0, 10))]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: kAccentGlow(), blurRadius: 16)],
                ),
                alignment: Alignment.center,
                child: FaIcon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: poppins(
                        size: 11.5,
                        weight: FontWeight.w600,
                        spacing: 1,
                      ).copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value ?? '',
                      style: poppins(size: 15, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
