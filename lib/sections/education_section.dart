import 'package:flutter/material.dart';
import 'package:portfolio_flutter/data.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.to;
    final padH = (MediaQuery.sizeOf(context).width * 0.09).clamp(24.0, 140.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 100, padH, 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: SectionLabel(text: settings.t('nav.education')),
          ),
          const SizedBox(height: 12),
          RevealOnScroll(child: SectionTitle(text: settings.t('edu.title'))),
          const SizedBox(height: 34),
          for (final item in kEduItems)
            RevealOnScroll(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _EduCard(item: item),
              ),
            ),
          const SizedBox(height: 8),
          RevealOnScroll(
            child: Wrap(
              spacing: 11,
              runSpacing: 11,
              children: [
                for (final tag in kEduTags)
                  ProjectTag(text: settings.t(tag)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EduCard extends StatelessWidget {
  const _EduCard({required this.item});

  final EduItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;

    return CardHover(
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 22,
          ),
          transform: hovering
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: hovering ? kAccent : colors.cardBorder),
            boxShadow: hovering
                ? [BoxShadow(color: kAccentGlow(), blurRadius: 30, offset: const Offset(0, 10))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.t(item.degreeKey),
                      style: poppins(size: 18, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settings.t(item.schoolKey),
                      style: poppins(size: 14.5)
                          .copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: kAccentGlow(), blurRadius: 12)],
                ),
                child: Text(
                  settings.t(item.dateKey),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}