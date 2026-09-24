import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_flutter/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpIcon(WidgetTester tester, Widget widget) async {
    await tester.binding.setSurfaceSize(const Size(400, 400));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: widget),
        ),
      ),
    );
    await tester.pump();
  }

  String glyphOffsetLabel(WidgetTester tester, Finder iconFinder) {
    final paragraphs = tester.allRenderObjects
        .whereType<RenderParagraph>()
        .toList();
    expect(paragraphs, isNotEmpty);
    final rp = paragraphs.single;
    final rect = rp.localToGlobal(Offset.zero) & rp.size;
    final glyph =
        rp.getBoxesForSelection(
            const TextSelection(baseOffset: 0, extentOffset: 1));
    final g = glyph.first.toRect().shift(rect.topLeft);
    final glyphCenter = g.center;
    final boxCenter = rect.center;
    return 'glyphCenter=$glyphCenter boxCenter=$boxCenter dy=${(glyphCenter.dy - boxCenter.dy).toStringAsFixed(1)}';
  }

  testWidgets('social icon glyph is centered in circle', (tester) async {
    await pumpIcon(
      tester,
      const SocialIconButton(
        icon: FontAwesomeIcons.github,
        url: 'https://github.com/panhahoun',
        size: 54,
      ),
    );
    final out = glyphOffsetLabel(tester, find.byType(FaIcon));
    // ignore: avoid_print
    print('SocialIconButton: $out');
    final match = RegExp(r'dy=([-0-9.]+)').firstMatch(out)!;
    final dy = double.parse(match.group(1)!);
    expect(dy.abs(), lessThan(2.0),
        reason: 'glyph must be centered vertically in the circle');
  });
}