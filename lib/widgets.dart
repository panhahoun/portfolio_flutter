import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_flutter/data.dart';
import 'package:portfolio_flutter/controllers/home_controller.dart';
import 'package:portfolio_flutter/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/* ─────────────────────────── Reveal on scroll ─────────────────────────── */

class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offset = 32,
    this.threshold = 0.86,
  });

  final Widget child;
  final Duration duration;
  final double offset;
  final double threshold;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  bool _triggered = false;
  bool _attached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attached) {
      _attached = true;
      final controller = HomeController.to.scroll;
      controller.addListener(_check);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _check();
      });
    }
  }

  void _check() {
    if (_triggered || !mounted) return;
    final scroll = HomeController.to.scroll;
    if (!scroll.hasClients) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top <= viewport * widget.threshold) {
      _triggered = true;
      scroll.removeListener(_check);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (_attached) {
      HomeController.to.scroll.removeListener(_check);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, widget.offset * (1 - _curve.value)),
            child: child,
          ),
        );
      },
    );
  }
}

/* ─────────────────────────── Typing animation ─────────────────────────── */

class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.words,
    this.style,
    this.cursorColor = kAccent,
    this.cursorHeight = 30,
  });

  final List<String> words;
  final TextStyle? style;
  final Color cursorColor;
  final double cursorHeight;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  Timer? _timer;
  int _wi = 0;
  int _ci = 0;
  bool _deleting = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _tick();
  }

  @override
  void didUpdateWidget(covariant TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.words, widget.words)) {
      _timer?.cancel();
      _wi = 0;
      _ci = 0;
      _deleting = false;
      _text = '';
      _tick();
    }
  }

  void _tick() {
    if (!mounted) return;
    final words = widget.words;
    if (words.isEmpty) {
      setState(() => _text = '');
      return;
    }
    final word = words[_wi % words.length];
    if (!_deleting) {
      _ci++;
      _text = word.substring(0, math.min(_ci, word.length));
      if (_ci >= word.length) {
        _deleting = true;
        _timer = Timer(const Duration(milliseconds: 1700), _tick);
      } else {
        _timer = Timer(const Duration(milliseconds: 85), _tick);
      }
    } else {
      _ci--;
      _text = word.substring(0, math.max(_ci, 0));
      if (_ci <= 0) {
        _deleting = false;
        _wi++;
      }
      _timer = Timer(const Duration(milliseconds: 45), _tick);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: [
        Text(_text, style: widget.style),
        AnimatedBuilder(
          animation: _blink,
          builder: (context, _) => Container(
            width: 3,
            height: widget.cursorHeight,
            color: widget.cursorColor
                .withValues(alpha: 0.3 + _blink.value * 0.7),
          ),
        ),
      ],
    );
  }
}

/* ─────────────────────────── Section header bits ───────────────────────── */

class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.text,
    this.color = kAccent,
    this.centered = false,
    this.lineAfter = false,
  });

  final String text;
  final Color color;
  final bool centered;
  final bool lineAfter;

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: 45,
      height: 2,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [BoxShadow(color: kAccentGlow(), blurRadius: 10)],
      ),
    );
    final label = Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 4,
        height: 1.2,
      ),
    );
    final gap = SizedBox(width: 12);
    if (centered) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [line, gap, Flexible(child: label), gap, line],
      );
    }
    if (lineAfter) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Flexible(child: label), gap, line],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [line, gap, Flexible(child: label)],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.text,
    this.centered = false,
    this.color,
  });

  final String text;
  final bool centered;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: centered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
      ),
    );
  }
}

/* ────────────────────────────── Card hover ────────────────────────────── */

class CardHover extends StatefulWidget {
  const CardHover({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
  });

  final Widget Function(BuildContext context, bool hovering) builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;
  final bool enabled;

  @override
  State<CardHover> createState() => _CardHoverState();
}

class _CardHoverState extends State<CardHover> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? widget.cursor : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: widget.builder(context, _hovering),
      ),
    );
  }
}

/* ─────────────────────────── Skill chip ──────────────────────────────── */

class SkillChip extends StatelessWidget {
  const SkillChip({super.key, required this.item});

  final ChipItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CardHover(
      builder: (context, hovering) {
        return Opacity(
          opacity: item.off ? 0.55 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: hovering
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: hovering ? kAccent : colors.cardBorder,
              ),
              boxShadow: hovering
                  ? [BoxShadow(color: kAccentGlow(), blurRadius: 14)]
                  : null,
            ),
            child: Text.rich(
              TextSpan(children: [
                for (final seg in item.segs)
                  TextSpan(
                    text: seg.text,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight:
                          seg.bold ? FontWeight.w700 : FontWeight.w500,
                      color: seg.bold ? kAccent : colors.text,
                    ),
                  ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

/* ─────────────────────────── Project tag pill ────────────────────────── */

class ProjectTag extends StatelessWidget {
  const ProjectTag({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        color: kAccent,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [BoxShadow(color: kAccentGlow(), blurRadius: 12)],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/* ─────────────────────────── Social icon button ──────────────────────── */

class SocialIconButton extends StatefulWidget {
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.url,
    this.size = 54,
    this.asset = false,
    this.onTap,
  });

  final FaIconData icon;
  final String? url;
  final double size;
  final bool asset;
  final VoidCallback? onTap;

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _hovering = false;

  void _open() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    if (widget.url == null) return;
    launchUrl(Uri.parse(widget.url!), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _open,
        child: AnimatedScale(
          scale: _hovering ? 1.15 : 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _hovering ? const Offset(0, -0.06) : Offset.zero,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovering ? kAccent : Colors.transparent,
                border: Border.all(color: kAccent, width: 2),
                boxShadow: _hovering
                    ? [BoxShadow(color: kAccentGlow(), blurRadius: 26)]
                    : null,
              ),
              child: FaIcon(
                widget.icon,
                size: widget.size * 0.4,
                color: _hovering ? Colors.white : kAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────── Pill buttons ────────────────────────────── */

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return CardHover(
      onTap: onTap,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: hovering
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
          decoration: BoxDecoration(
            color: filled || hovering ? kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: kAccent, width: 2),
            boxShadow: hovering && (filled)
                ? [BoxShadow(color: kAccentGlow(), blurRadius: 26)]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: filled || hovering ? Colors.white : kAccent,
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
}

/* ─────────────────────────── Floating orbs ────────────────────────────── */

class FloatingOrbs extends StatefulWidget {
  const FloatingOrbs({super.key, required this.color, this.blur = 90});
  final Color color;
  final double blur;

  @override
  State<FloatingOrbs> createState() => _FloatingOrbsState();
}

class _FloatingOrbsState extends State<FloatingOrbs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat(reverse: true);

  Widget _orb(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 1),
              color.withValues(alpha: 0),
            ],
            stops: const [0.35, 1],
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * 2 * math.pi;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 30,
                left: -80,
                child: Transform.translate(
                  offset: Offset(28 * math.sin(t), -34 * math.sin(t)),
                  child: _orb(160, widget.color),
                ),
              ),
              Positioned(
                bottom: -20,
                right: -80,
                child: Transform.translate(
                  offset: Offset(36 * math.sin(t + math.pi),
                      34 * math.cos(t + math.pi)),
                  child: _orb(140, widget.color),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ─────────────────────────── Portrait painters ────────────────────────── */

class EllipseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()..addOval(Offset.zero & size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DashedEllipsePainter extends CustomPainter {
  DashedEllipsePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
    final rect = Offset.zero & size;
    final path = Path()..addOval(rect);
    const dash = 10.0;
    const gap = 8.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dash);
        canvas.drawPath(segment, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedEllipsePainter oldDelegate) =>
      oldDelegate.color != color;
}

class EllipseGlowBorderPainter extends CustomPainter {
  const EllipseGlowBorderPainter({required this.color, this.glow = true});
  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(3);
    if (glow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
      canvas.drawOval(rect, glowPaint);
    }
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color;
    canvas.drawOval(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant EllipseGlowBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.glow != glow;
}

class SpinningDashedRing extends StatelessWidget {
  const SpinningDashedRing({
    super.key,
    required this.color,
    required this.borderWidth,
  });

  final Color color;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 26),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: 2 * math.pi * value,
          child: child,
        );
      },
      child: CustomPaint(
        painter: DashedEllipsePainter(color: color),
        size: Size.square(borderWidth),
      ),
    );
  }
}

/* ─────────────────────────── Bold text renderer ───────────────────────── */

List<TextSpan> richSpans(
  String text, {
  required TextStyle base,
  TextStyle? bold,
}) {
  final spans = <TextSpan>[];
  final parts = text.split('**');
  for (var i = 0; i < parts.length; i++) {
    if (parts[i].isEmpty) continue;
    spans.add(TextSpan(
      text: parts[i],
      style: i.isOdd ? (bold ?? base) : base,
    ));
  }
  return spans;
}

TextStyle poppins({
  required double size,
  FontWeight weight = FontWeight.w500,
  double height = 1.2,
  double? spacing,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: spacing,
  );
}