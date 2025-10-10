import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerData {
  final String message;
  final bool isError;
  const BannerData(this.message, {this.isError = false});
}

enum EmailState {
  idle,          // لا شيء
  checking,      // جاري التحقق...
  valid,         // ✔️ صالح
  invalidFormat, // بريد غير صالح
  alreadyUsed,   // مستخدم مسبقًا
}

class EditEmailController extends GetxController {
  late final TextEditingController emailController;

  // حالة الحقل
  final emailState = EmailState.idle.obs;

  // لظهور/اختفاء زر التحديث
  final canSave = false.obs;
  final saving = false.obs;

  // إشعار علوي (بانر)
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
    // رجّع الحالة للوضع الافتراضي عند أي تغيير
    emailState.value = EmailState.idle;
    canSave.value = v.trim().isNotEmpty;
  }

  // التحقق البسيط من صيغة البريد
  bool _isEmailFormatValid(String email) {
    final regex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regex.hasMatch(email);
  }

  // محاكاة تحقق لمدة 5 ثواني ثم إعطاء نتيجة مثل الصور
  Future<void> save() async {
    final email = emailController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();

    if (email.isEmpty) return;

    // ابدأ التحقق
    emailState.value = EmailState.checking;
    canSave.value = false;
    _hideBanner();

    // انتظر 5 ثوانٍ لمحاكاة الاتصال بالسيرفر
    await Future.delayed(const Duration(seconds: 5));

    // حدّد النتيجة:
    if (!_isEmailFormatValid(email)) {
      // بريد غير صالح
      emailState.value = EmailState.invalidFormat;
      _showBanner('أدخل عنوان بريد إلكتروني صالح', isError: true);
      canSave.value = false;
      return;
    }

    // مستخدم مسبقًا (قيمة محاكية كما اتفقنا)
    final usedByOther = email.contains('1@') || email.endsWith('.1com');
    if (usedByOther) {
      emailState.value = EmailState.alreadyUsed;
      _showBanner('تم التحقق من البريد الإلكتروني بواسطة حساب آخر.\nيرجى إدخال بريد إلكتروني آخر.', isError: true);
      canSave.value = false;
      return;
    }

    // صالح ✔️
    emailState.value = EmailState.valid;
    _showBanner('لقد تم تغيير بريدك الإلكتروني بنجاح.', isError: false);
    canSave.value = true;
  }

  void _showBanner(String msg, {required bool isError}) {
    banner.value = BannerData(msg, isError: isError);
    bannerShown.value = true;
    // إخفاء تلقائي بعد 2.5 ثانية
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
