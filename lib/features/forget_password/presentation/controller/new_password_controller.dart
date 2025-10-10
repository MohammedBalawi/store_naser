// lib/features/auth/presentation/controller/new_password_controller.dart
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  final password = ''.obs;
  final obscure = true.obs;

  bool get validPass => password.value.length >= 8;

  void onPassChanged(String v) => password.value = v;
  void toggleObscure() => obscure.value = !obscure.value;
}
