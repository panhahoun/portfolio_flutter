import 'package:get/get.dart';
import 'package:portfolio_flutter/controllers/settings_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController(), permanent: true);
  }
}