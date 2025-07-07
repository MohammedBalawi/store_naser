import 'package:get/get.dart';
import '../../presentation/controller/profile_controller.dart';

initProfile() {
  Get.put(ProfileController());
}

disposeProfile() {
  Get.delete<ProfileController>();
}
