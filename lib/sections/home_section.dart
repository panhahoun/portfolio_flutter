import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/data.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:portfolio_flutter/widgets.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.onViewWork,
    required this.onContactMe,
  });

  final VoidCallback onViewWork;
  final VoidCallback onContactMe;

  static const _github = 'https://github.com/panhahoun';
  static const _linkedin =
      'https://www.linkedin.com/in/houn-panha-2ab2ab325';
  static const _email = 'mailto:hournpanha168@gmail.com';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubble = kAccent.withValues(alpha: isDark ? 0.14 : 0.10);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: FloatingOrbs(color: bubble)),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isDesktop = constraints.maxWidth > 995;
            final padH = (width * 0.09).clamp(24.0, 140.0);
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).height,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padH,
                  isDesktop ? 150 : 180,
                  padH,
                  60,
                ),
                child: isDesktop
                    ? _DesktopLayout(
                        onViewWork: onViewWork,
                        onContactMe: onContactMe,
                      )
                    : _MobileLayout(
                        onViewWork: onViewWork,
                        onContactMe: onContactMe,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.large});

  final bool large;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.to;
    final colors = context.colors;
    final nameSize = large ? 54.0 : 42.0;
    final typingSize = large ? 28.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: large
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        RevealOnScroll(
          child: SectionLabel(text: settings.t('hero.eyebrow'), lineAfter: true),
        ),
        const SizedBox(height: 14),
        RevealOnScroll(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: '${settings.t('hero.hello')} ',
                style: poppins(
                  size: nameSize,
                  weight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              TextSpan(
                text: settings.t('hero.name'),
                style: poppins(
                  size: nameSize,
                  weight: FontWeight.w700,
                  height: 1.25,
                ).copyWith(
                  color: kAccent,
                  shadows: [Shadow(color: kAccentGlow(), blurRadius: 18)],
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 6),
        RevealOnScroll(
          child: Wrap(
            alignment: large
                ? WrapAlignment.start
                : WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              Text(
                '${settings.t('hero.typePrefix')} ',
                style: poppins(
                  size: typingSize,
                  weight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              TypingText(
                words: settings.typingWords,
                cursorHeight: typingSize * 1.1,
                style: poppins(
                  size: typingSize,
                  weight: FontWeight.w600,
                  height: 1.2,
                ).copyWith(color: kAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        RevealOnScroll(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              settings.t('hero.intro'),
              textAlign: TextAlign.justify,
              style: poppins(
                size: 17,
                weight: FontWeight.w400,
                height: 1.75,
              ).copyWith(color: colors.muted),
            ),
          ),
        ),
      ],
    );
  }
}

class _Socials extends StatelessWidget {
  const _Socials();

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SocialIconButton(
            icon: FontAwesomeIcons.github,
            url: HomeSection._github,
          ),
          SizedBox(width: 26),
          SocialIconButton(
            icon: FontAwesomeIcons.linkedinIn,
            url: HomeSection._linkedin,
          ),
          SizedBox(width: 26),
          SocialIconButton(
            icon: FontAwesomeIcons.solidEnvelope,
            url: HomeSection._email,
          ),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats({required this.large});
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = SettingsController.to;
    return RevealOnScroll(
      child: Wrap(
        alignment: large ? WrapAlignment.start : WrapAlignment.center,
        spacing: large ? 72 : 32,
        runSpacing: 14,
        children: [
          for (final stat in kStats)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.value,
                  style: poppins(
                    size: 26,
                    weight: FontWeight.w800,
                    height: 1.1,
                  ).copyWith(color: kAccent),
                ),
                const SizedBox(height: 3),
                Text(
                  settings.t(stat.labelKey).toUpperCase(),
                  style: poppins(
                    size: 12.5,
                    weight: FontWeight.w500,
                    height: 1.2,
                    spacing: 1.5,
                  ).copyWith(color: colors.muted),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.onViewWork, required this.onContactMe});

  final VoidCallback onViewWork;
  final VoidCallback onContactMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroText(large: true),
              const SizedBox(height: 26),
              const _Socials(),
              const SizedBox(height: 34),
              RevealOnScroll(
                child: Row(
                  children: [
                    PillButton(
                      label: SettingsController.to.t('hero.btnWork'),
                      onTap: onViewWork,
                    ),
                    const SizedBox(width: 26),
                    PillButton(
                      label: SettingsController.to.t('hero.btnContact'),
                      onTap: onContactMe,
                      filled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              _HeroStats(large: true),
            ],
          ),
        ),
        const SizedBox(width: 112),
        const _Portrait(size: 300),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.onViewWork, required this.onContactMe});

  final VoidCallback onViewWork;
  final VoidCallback onContactMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _HeroText(large: false),
        const SizedBox(height: 22),
        const _Socials(),
        const SizedBox(height: 30),
        RevealOnScroll(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 26,
            runSpacing: 12,
            children: [
              PillButton(
                label: SettingsController.to.t('hero.btnWork'),
                onTap: onViewWork,
              ),
              PillButton(
                label: SettingsController.to.t('hero.btnContact'),
                onTap: onContactMe,
                filled: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        _HeroStats(large: false),
        const SizedBox(height: 52),
        const _Portrait(size: 240),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final glow = kAccentGlow();
    const fallback = 'assets/images/portrait_fallback.png';
    const photo = 'assets/images/portrait.JPG';

    return RevealOnScroll(
      child: SizedBox(
        width: size + 26,
        height: size * 4 / 3 + 26,
        child: Stack(
          children: [
            Positioned.fill(
              child: SpinningDashedRing(
                color: kAccent.withValues(alpha: 0.7),
                borderWidth: size + 26,
              ),
            ),
            Positioned(
              left: 13,
              top: 13,
              right: 13,
              bottom: 13,
              child: SizedBox(
                width: size,
                height: size * 4 / 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: glow, blurRadius: 40)],
                    shape: BoxShape.circle,
                  ),
                  child: CustomPaint(
                    painter: const EllipseGlowBorderPainter(color: kAccent),
                    child: ClipPath(
                      clipper: EllipseClipper(),
                      child: Image.asset(
                        photo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Image.asset(
                          fallback,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}