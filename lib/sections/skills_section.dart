import 'package:flutter/material.dart';
import 'package:portfolio_flutter/data.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;
    final padH = (MediaQuery.sizeOf(context).width * 0.09).clamp(24.0, 140.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 100, padH, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(child: SectionLabel(text: settings.t('nav.skills'))),
          const SizedBox(height: 14),
          RevealOnScroll(child: SectionTitle(text: settings.t('skills.title'))),
          const SizedBox(height: 40),
          Column(
            children: [
              for (final group in kSkillGroups)
                RevealOnScroll(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: _SkillGroupView(group: group, colors: colors),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillGroupView extends StatelessWidget {
  const _SkillGroupView({required this.group, required this.colors});

  final SkillGroup group;
  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  SettingsController.to.t(group.titleKey).toUpperCase(),
                  style: poppins(
                    size: 15,
                    weight: FontWeight.w700,
                    spacing: 1.5,
                  ).copyWith(color: kAccent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.cardBorder,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [for (final chip in group.items) SkillChip(item: chip)],
        ),
      ],
    );
  }
}