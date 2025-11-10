import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/routes.dart';

class VerificationController extends GetxController {
  late final String phoneDisplay;

  late final TextEditingController firstCodeTextController;
  late final TextEditingController secondCodeTextController;
  late final TextEditingController thirdCodeTextController;
  late final TextEditingController fourthCodeTextController;

  late final FocusNode firstFocusNode;
  late final FocusNode secondFocusNode;
  late final FocusNode thirdFocusNode;
  late final FocusNode fourthFocusNode;

  final code = ''.obs;
  final hasError = false.obs;
  final secondsLeft = 54.obs;
  final canResend = false.obs;
  Timer? _timer;

  final String expectedCode = '2222';

  String otp() =>
      '${firstCodeTextController.text}'
          '${secondCodeTextController.text}'
          '${thirdCodeTextController.text}'
          '${fourthCodeTextController.text}';

  bool get ready => code.value.length == 4 && !hasError.value;

  @override
  void onInit() {
    super.onInit();
    phoneDisplay = Get.arguments?['phone'] ?? '';

    firstCodeTextController = TextEditingController();
    secondCodeTextController = TextEditingController();
    thirdCodeTextController = TextEditingController();
    fourthCodeTextController = TextEditingController();

    firstFocusNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fourthFocusNode = FocusNode();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  void onBoxChanged(int index, String v) {
    hasError.value = false;
    final last = v.isEmpty ? '' : v.characters.last;
    switch (index) {
      case 0:
        firstCodeTextController.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) secondFocusNode.requestFocus();
        break;
      case 1:
        secondCodeTextController.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) thirdFocusNode.requestFocus();
        if (last.isEmpty) firstFocusNode.requestFocus();
        break;
      case 2:
        thirdCodeTextController.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isNotEmpty) fourthFocusNode.requestFocus();
        if (last.isEmpty) secondFocusNode.requestFocus();
        break;
      case 3:
        fourthCodeTextController.value = TextEditingValue(
          text: last,
          selection: const TextSelection.collapsed(offset: 1),
        );
        if (last.isEmpty) thirdFocusNode.requestFocus();
        break;
    }
    _rebuildCode();
  }

  void _rebuildCode() {
    code.value = otp();
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
    // TODO: نداء API لإعادة إرسال الرمز (إن وُجد)
  }



  void submit() {
    if (code.value.length != 4) return;

    if (code.value != '2222') {
      hasError.value = true;
      return;
    }

    _timer?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();

    Get.back();


  }


  @override
  void onClose() {
    _timer?.cancel();

    firstCodeTextController.dispose();
    secondCodeTextController.dispose();
    thirdCodeTextController.dispose();
    fourthCodeTextController.dispose();

    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    super.onClose();
  }
}
