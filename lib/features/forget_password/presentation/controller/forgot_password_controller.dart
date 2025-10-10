// lib/features/auth/presentation/controller/forgot_password_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../view/email_verification_view.dart';
import 'email_verification_controller.dart';

class ForgotPasswordController extends GetxController {
  final email = ''.obs;
  final showNotRegistered = false.obs;

  bool get validEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.value.trim());

  void onEmailChanged(String v) {
    email.value = v.trim();
    showNotRegistered.value = false; // أخفِ الخطأ عند التعديل
  }

  // محاكاة: لو البريد ينتهي بـ "gmail.com" اعتبره مسجّل، غير ذلك غير مسجل
// lib/features/auth/presentation/controller/forgot_password_controller.dart


  Future<void> send() async {
    if (!validEmail) return;

    // محاكاة التسجيل
    final registered = email.value.toLowerCase().endsWith('gmail.com');
    if (!registered) {
      showNotRegistered.value = true;
      return;
    }

    Get.to(
          () => const EmailVerificationView(),
      binding: BindingsBuilder(() {
        Get.put(EmailVerificationController());
      }),
      arguments: {'email': email.value},
    );
  }

}
