import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/data.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

void launchGitHub(String url) {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.to;
    final padH = (MediaQuery.sizeOf(context).width * 0.09).clamp(24.0, 140.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 100, padH, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(child: SectionLabel(text: settings.t('nav.projects'))),
          const SizedBox(height: 14),
          RevealOnScroll(
            child: SectionTitle(text: settings.t('projects.title')),
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              for (final project in kProjects)
                RevealOnScroll(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: _ProjectCard(project: project),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;

    return CardHover(
      builder: (context, hovering) {
        final shown = hovering;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: shown
              ? Matrix4.translationValues(0, -5, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: shown ? kAccent : colors.cardBorder),
            boxShadow: shown
                ? [
                    BoxShadow(
                      color: kAccentGlow(),
                      blurRadius: 44,
                      offset: const Offset(0, 14),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.t(project.titleKey),
                          style: poppins(size: 20, weight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          settings.t(project.taglineKey),
                          style: poppins(
                            size: 13.5,
                            weight: FontWeight.w500,
                          ).copyWith(color: colors.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: kAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: kAccentGlow(), blurRadius: 12),
                      ],
                    ),
                    child: Text(
                      settings.t(project.roleKey),
                      style: const TextStyle(
                        color: kAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              for (final bodyKey in project.bodyKeys)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kAccent,
                          boxShadow: [
                            BoxShadow(color: kAccentGlow(), blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          settings.t(bodyKey),
                          style: poppins(
                            size: 15,
                            height: 1.7,
                          ).copyWith(color: colors.muted),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in project.tags) ProjectTag(text: tag),
                ],
              ),
              const SizedBox(height: 20),
              CardHover(
                onTap: () => launchGitHub(project.link),
                builder: (context, _) => RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: FaIcon(FontAwesomeIcons.github, size: 16),
                      ),
                      const WidgetSpan(child: SizedBox(width: 10)),
                      const TextSpan(
                        text: 'GitHub',
                        style: TextStyle(
                          color: kAccent,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
