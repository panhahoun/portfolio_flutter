import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  static const sectionCount = 6;
  static const double headerBottom = 90;

  final ScrollController scroll = ScrollController();
  final RxBool scrolled = false.obs;
  final RxInt activeIndex = 0.obs;
  final List<GlobalKey> sectionKeys =
      List.generate(sectionCount, (_) => GlobalKey());

  bool get isDesktop => Get.width > 995;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_onScroll);
  }

  @override
  void onClose() {
    scroll.removeListener(_onScroll);
    scroll.dispose();
    super.onClose();
  }

  void _onScroll() {
    final offset = scroll.offset;
    if ((offset > 30) != scrolled.value) scrolled.value = offset > 30;

    final line = HomeController.headerBottom;
    int active = 0;
    for (var i = 0; i < sectionCount; i++) {
      final renderObject = sectionKeys[i].currentContext?.findRenderObject();
      if (renderObject is! RenderBox) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= line) {
        active = i;
      } else {
        break;
      }
    }
    if (active != activeIndex.value) activeIndex.value = active;
  }

  void scrollTo(int index) {
    if (index < 0 || index >= sectionCount) return;
    if (!scroll.hasClients) return;

    final double target;
    if (index == sectionCount - 1) {
      target = scroll.position.maxScrollExtent;
    } else {
      final renderObject =
          sectionKeys[index].currentContext?.findRenderObject();
      if (renderObject is! RenderBox) return;
      final dy = renderObject.localToGlobal(Offset.zero).dy;
      target = (scroll.offset + dy - 90).clamp(
            0.0,
            scroll.position.maxScrollExtent,
          );
    }
    scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }
}