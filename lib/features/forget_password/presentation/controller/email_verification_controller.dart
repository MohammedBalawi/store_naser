// lib/features/auth/presentation/controller/email_verification_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/new_password_view.dart';
import 'new_password_controller.dart';

class EmailVerificationController extends GetxController {
  late final String email;

  late final TextEditingController t1;
  late final TextEditingController t2;
  late final TextEditingController t3;
  late final TextEditingController t4;

  late final FocusNode f1;
  late final FocusNode f2;
  late final FocusNode f3;
  late final FocusNode f4;

  final code = ''.obs;
  final hasError = false.obs;
  final secondsLeft = 54.obs;
  final canResend = false.obs;
  Timer? _timer;

  // الرمز الصحيح المطلوب
  final String expected = '2222';

  bool get ready => code.value.length == 4 && !hasError.value;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';

    t1 = TextEditingController();
    t2 = TextEditingController();
    t3 = TextEditingController();
    t4 = TextEditingController();

    f1 = FocusNode();
    f2 = FocusNode();
    f3 = FocusNode();
    f4 = FocusNode();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  void onBoxChanged(int i, String v) {
    hasError.value = false;
    final last = v.isEmpty ? '' : v.characters.last;
    switch (i) {
      case 0:
        t1.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) f2.requestFocus();
        break;
      case 1:
        t2.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) {
          f3.requestFocus();
        } else {
          f1.requestFocus();
        }
        break;
      case 2:
        t3.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) {
          f4.requestFocus();
        } else {
          f2.requestFocus();
        }
        break;
      case 3:
        t4.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isEmpty) f3.requestFocus();
        break;
    }
    code.value = '${t1.text}${t2.text}${t3.text}${t4.text}';
  }

  void resend() {
    if (!canResend.value) return;
    secondsLeft.value = 54;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
    // TODO: نداء API لإعادة إرسال الرمز
  }

// lib/features/auth/presentation/controller/email_verification_controller.dart

  void submit() {
    if (code.value.length != 4) return;
    if (code.value != expected) {
      hasError.value = true;
      return;
    }
    _timer?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();

    Get.to(
          () => const NewPasswordView(),
      binding: BindingsBuilder(() {
        Get.put(NewPasswordController()); // <-- تسجيل الكونترولر
      }),
    );
  }


  @override
  void onClose() {
    _timer?.cancel();
    t1.dispose();
    t2.dispose();
    t3.dispose();
    t4.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    super.onClose();
  }
}