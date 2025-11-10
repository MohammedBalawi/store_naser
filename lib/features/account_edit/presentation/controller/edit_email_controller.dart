import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerData {
  final String message;
  final bool isError;
  const BannerData(this.message, {this.isError = false});
}

enum EmailState {
  idle,
  checking,
  valid,
  invalidFormat,
  alreadyUsed,
}

class EditEmailController extends GetxController {
  late final TextEditingController emailController;

  final emailState = EmailState.idle.obs;

  final canSave = false.obs;
  final saving = false.obs;

  final banner = Rx<BannerData?>(null);
  final bannerShown = false.obs;

  @override
  void onInit() {
    super.onInit();
    final initial = (Get.arguments?['email'] as String?) ?? '';
    emailController = TextEditingController(text: initial);
    canSave.value = initial.trim().isNotEmpty;
  }

  void onChanged(String v) {
    emailState.value = EmailState.idle;
    canSave.value = v.trim().isNotEmpty;
  }

  bool _isEmailFormatValid(String email) {
    final regex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regex.hasMatch(email);
  }

  Future<void> save() async {
    final email = emailController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();

    if (email.isEmpty) return;

    emailState.value = EmailState.checking;
    canSave.value = false;
    _hideBanner();

    await Future.delayed(const Duration(seconds: 5));

    if (!_isEmailFormatValid(email)) {
      emailState.value = EmailState.invalidFormat;
      _showBanner('أدخل عنوان بريد إلكتروني صالح', isError: true);
      canSave.value = false;
      return;
    }

    final usedByOther = email.contains('1@') || email.endsWith('.1com');
    if (usedByOther) {
      emailState.value = EmailState.alreadyUsed;
      _showBanner('تم التحقق من البريد الإلكتروني بواسطة حساب آخر.\nيرجى إدخال بريد إلكتروني آخر.', isError: true);
      canSave.value = false;
      return;
    }

    emailState.value = EmailState.valid;
    _showBanner('لقد تم تغيير بريدك الإلكتروني بنجاح.', isError: false);
    canSave.value = true;
  }

  void _showBanner(String msg, {required bool isError}) {
    banner.value = BannerData(msg, isError: isError);
    bannerShown.value = true;
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (banner.value?.message == msg) bannerShown.value = false;
    });
  }

  void _hideBanner() {
    bannerShown.value = false;
    banner.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
