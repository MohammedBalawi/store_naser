import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final newCtrl      = TextEditingController();
  final confirmCtrl  = TextEditingController();
  final obscureNew     = true.obs;
  final obscureConfirm = true.obs;

  final validLength = false.obs;
  final matchValid  = false.obs;

  final showIndicators = false.obs;

  final canSave = false.obs;

  final banner      = Rxn<_BannerState>();
  final bannerShown = false.obs;

  final saving = false.obs;

  bool _lenOk(String v) => v.trim().length >= 8;
  bool _matchOk(String a, String b) => a == b && b.trim().isNotEmpty;

  void onChangedNew(String v) {
    validLength.value = _lenOk(v);
    matchValid.value  = _matchOk(v, confirmCtrl.text);
    _recalc();
  }

  void onChangedConfirm(String v) {
    matchValid.value = _matchOk(newCtrl.text, v);
    _recalc();
  }

  void toggleObscureNew()     => obscureNew.toggle();
  void toggleObscureConfirm() => obscureConfirm.toggle();

  void _recalc() {
    canSave.value = validLength.value && matchValid.value;
  }

  void _showBanner(_BannerState s) async {
    banner.value = s;
    bannerShown.value = true;
    await Future.delayed(const Duration(milliseconds: 1800));
    bannerShown.value = false;
    await Future.delayed(const Duration(milliseconds: 320));
    banner.value = null;
  }

  Future<void> save() async {
    if (saving.value) return;

    showIndicators.value = true;

    if (!_matchOk(newCtrl.text, confirmCtrl.text)) {
      _showBanner(_BannerState.error("كلمتا المرور غير متطابقتين"));
      canSave.value = false;
      return;
    }

    if (!_lenOk(newCtrl.text)) {
      _showBanner(_BannerState.error("كلمة المرور الخاصة بك أقل من 8 أحرف"));
      canSave.value = false;
      return;
    }

    saving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      _showBanner(_BannerState.success("لقد تم تغيير كلمة المرور الخاصة بك بنجاح."));
      validLength.value = true;
      matchValid.value  = true;
      // newCtrl.clear(); confirmCtrl.clear();
      // showIndicators.value = false; canSave.value = false;
    } catch (_) {
      _showBanner(_BannerState.error("حدث خطأ غير متوقع. حاول مجددًا."));
    } finally {
      saving.value = false;
    }
  }

  @override
  void onClose() {
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}

class _BannerState {
  final bool isError;
  final String message;

  _BannerState._(this.isError, this.message);

  factory _BannerState.success(String msg) => _BannerState._(false, msg);
  factory _BannerState.error(String msg)   => _BannerState._(true, msg);
}
