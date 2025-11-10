// lib/features/account_edit/presentation/controller/phone_otp_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_phone_controller.dart';
import '../../../../core/resources/manager_colors.dart';

class PhoneOtpController extends GetxController {
  late final String phoneDisplay;

  late final TextEditingController t1, t2, t3, t4;
  late final FocusNode f1, f2, f3, f4;

  final code = ''.obs;
  final hasError = false.obs;

  final secondsLeft = 54.obs;
  final canResend = false.obs;
  Timer? _timer;

  final String expected = '2222';

  bool get ready => code.value.length == 4 && !hasError.value;

  @override
  void onInit() {
    super.onInit();
    phoneDisplay = Get.arguments?['phone'] ?? '';

    t1 = TextEditingController();
    t2 = TextEditingController();
    t3 = TextEditingController();
    t4 = TextEditingController();

    f1 = FocusNode(); f2 = FocusNode(); f3 = FocusNode(); f4 = FocusNode();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) secondsLeft.value--;
      else { canResend.value = true; t.cancel(); }
    });
  }

  void onBoxChanged(int i, String v) {
    hasError.value = false;
    final last = v.isEmpty ? '' : v.characters.last;

    void set(TextEditingController c, FocusNode? next, FocusNode? prev) {
      c.value = TextEditingValue(text: last, selection: const TextSelection.collapsed(offset: 1));
      if (last.isNotEmpty && next != null) next.requestFocus();
      if (last.isEmpty && prev != null) prev.requestFocus();
    }

    switch (i) {
      case 0: set(t1, f2, null); break;
      case 1: set(t2, f3, f1); break;
      case 2: set(t3, f4, f2); break;
      case 3: set(t4, null, f3); break;
    }

    code.value = '${t1.text}${t2.text}${t3.text}${t4.text}';
  }

  void resend() {
    if (!canResend.value) return;
    secondsLeft.value = 54;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) secondsLeft.value--;
      else { canResend.value = true; t.cancel(); }
    });
    // TODO: call resend API
  }

  void submit() {
    if (code.value.length != 4) return;
    if (code.value != expected) {
      hasError.value = true;
      return;
    }

    _timer?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();

    final changePhone = Get.find<ChangePhoneController>();
    changePhone.applySuccessAndReset(phoneDisplay);

    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    t1.dispose(); t2.dispose(); t3.dispose(); t4.dispose();
    f1.dispose(); f2.dispose(); f3.dispose(); f4.dispose();
    super.onClose();
  }
}
