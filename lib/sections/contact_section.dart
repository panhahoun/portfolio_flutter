import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.to;
    final padH = (MediaQuery.sizeOf(context).width * 0.09).clamp(24.0, 140.0);

    const linkData = [
      (
        icon: FontAwesomeIcons.solidEnvelope,
        label: 'hournpanha168@gmail.com',
        url: 'mailto:hournpanha168@gmail.com',
      ),
      (icon: FontAwesomeIcons.github, label: 'GitHub', url: 'https://github.com/panhahoun'),
      (
        icon: FontAwesomeIcons.linkedinIn,
        label: 'LinkedIn',
        url: 'https://www.linkedin.com/in/houn-panha-2ab2ab325',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padH, 100, padH, 100),
      decoration: BoxDecoration(gradient: contactGradient()),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              RevealOnScroll(
                child: SectionLabel(
                  text: settings.t('nav.contact'),
                  color: const Color(0xFFBAE0FF),
                  centered: true,
                ),
              ),
              const SizedBox(height: 14),
              RevealOnScroll(
                child: SectionTitle(
                  text: settings.t('contact.title'),
                  centered: true,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              RevealOnScroll(
                child: Text(
                  settings.t('contact.desc'),
                  textAlign: TextAlign.center,
                  style: poppins(size: 16, height: 1.6)
                      .copyWith(color: const Color(0xFFDCEDFF)),
                ),
              ),
              const SizedBox(height: 34),
              RevealOnScroll(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    for (final link in linkData)
                      _ContactLink(
                        icon: link.icon,
                        label: link.label,
                        url: link.url,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.icon,
    required this.label,
    required this.url,
  });

  final FaIconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return CardHover(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: hovering
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
          decoration: BoxDecoration(
            color: hovering ? Colors.white : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: hovering ? 0 : 0.45),
            ),
            boxShadow: hovering
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 10))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 15,
                color: hovering ? kAccentStrong : Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: poppins(size: 15, weight: FontWeight.w600)
                    .copyWith(color: hovering ? kAccentStrong : Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}