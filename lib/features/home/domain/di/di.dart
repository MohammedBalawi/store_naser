import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/controller/home_controller.dart';

Future<void> initHome() async {
  if (!Get.isRegistered<HomeController>()) {
    Get.put(HomeController());
  }
}

void disposeHome() {
  if (Get.isRegistered<HomeController>()) {
    Get.delete<HomeController>();
  }
}
