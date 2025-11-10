// lib/features/auth/presentation/controller/signup_controller.dart
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../verification/presentation/controller/verification_controller.dart';
import '../../../verification/presentation/view/verification_view.dart';

import '../../data/auth_repository.dart';
import '../../data/auth_remote.dart';
import '../../data/models/auth_response.dart';
// import '../../../../core/service/fcm_token_provider.dart';

class GulfCountry {
  final String name, dialCode, flagAsset;
  final int minLen;
  const GulfCountry({required this.name, required this.dialCode, required this.flagAsset, required this.minLen});
}

class SignUpController extends GetxController {
  final name = ''.obs;
  final phoneLocal = ''.obs;
  final email = ''.obs;
  final password = ''.obs;

  final showErrors = false.obs;
  final obscure = true.obs;
  void toggleObscure() => obscure.value = !obscure.value;

  final List<GulfCountry> gulfCountries = const [
    GulfCountry(name: 'المملكة العربية السعودية', dialCode: '+966', flagAsset: ManagerImages.su, minLen: 9),
    GulfCountry(name: 'الكويت',                 dialCode: '+965', flagAsset: ManagerImages.kw, minLen: 8),
    GulfCountry(name: 'الإمارات العربية المتحدة', dialCode: '+971', flagAsset: ManagerImages.ae, minLen: 9),
    GulfCountry(name: 'البحرين',                 dialCode: '+973', flagAsset: ManagerImages.bh, minLen: 8),
    GulfCountry(name: 'عمان',                    dialCode: '+968', flagAsset: ManagerImages.om, minLen: 8),
    GulfCountry(name: 'قطر',                     dialCode: '+974', flagAsset: ManagerImages.qa, minLen: 8),
  ];
  final Rx<GulfCountry> selected = const GulfCountry(
    name: 'المملكة العربية السعودية', dialCode: '+966', flagAsset: ManagerImages.su, minLen: 9,
  ).obs;

  final focusName = FocusNode();
  final focusPhone = FocusNode();
  final focusEmail = FocusNode();
  final focusPass = FocusNode();

  final tosRecognizer = TapGestureRecognizer()..onTap = () {};
  final privacyRecognizer = TapGestureRecognizer()..onTap = () {};

  bool get validName  => name.value.trim().isNotEmpty;
  bool get validPhone => RegExp(r'^\d+$').hasMatch(phoneLocal.value) && phoneLocal.value.length >= selected.value.minLen;
  bool get validEmail => email.value.trim().isEmpty // اختياري
      || RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.value.trim());
  bool get validPass  => password.value.length >= 8;

  bool get canSubmit  => validName && validPhone && validPass && validEmail;

  String get phoneErrorText => '${ManagerStrings.enterValidNumber} (${selected.value.minLen}+ أرقام)';
  void onPhoneChanged(String v) => phoneLocal.value = v.replaceAll(' ', '');

  void pickCountry(GulfCountry c) { selected.value = c; phoneLocal.refresh(); }

  final _repo = AuthRepository(AuthRemote());
  final isSubmitting = false.obs;
  AuthData? current;

  void onSubmitPressed() {
    if (!showErrors.value) showErrors.value = true;
    if (canSubmit) submit();
    else {
      if (!validName)      FocusScope.of(Get.context!).requestFocus(focusName);
      else if (!validPhone)FocusScope.of(Get.context!).requestFocus(focusPhone);
      else if (!validEmail)FocusScope.of(Get.context!).requestFocus(focusEmail);
      else if (!validPass) FocusScope.of(Get.context!).requestFocus(focusPass);
    }
  }

  Future<void> openCountryMenu(BuildContext ctx, GlobalKey anchorKey) async {
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(ctx, rootOverlay: true).context.findRenderObject() as RenderBox;
    final pos = RelativeRect.fromRect(
      Rect.fromLTWH(
        box.localToGlobal(Offset.zero, ancestor: overlay).dx,
        box.localToGlobal(Offset.zero, ancestor: overlay).dy + box.size.height + 4,
        box.size.width, box.size.height,
      ),
      Offset.zero & overlay.size,
    );
    final chosen = await showMenu<GulfCountry>(
      context: ctx,
      position: pos,
      constraints: const BoxConstraints.tightFor(width: 160),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: gulfCountries.map((e) => PopupMenuItem<GulfCountry>(
        value: e, height: 44, padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
              mainAxisSize: MainAxisSize.min, children: [
            Image.asset(e.flagAsset, width: 24, height: 16, fit: BoxFit.cover),
            const SizedBox(width: 8),

            Text(e.dialCode, style: getRegularTextStyle(fontSize: 16, color: Colors.black)),
          ]),
        ),
      )).toList(),
    );
    if (chosen != null) pickCountry(chosen);
  }

  Future<void> submit() async {
    final msisdn = _composeInternationalMsisdn(selected.value.dialCode, phoneLocal.value); // 9655500xxxx
    isSubmitting.value = true;
    try {
      // final fcm = await FcmTokenProvider.getTokenOrNull();

      current = await _repo.register(
        name: name.value.trim(),
        mobile: msisdn,
        password: password.value,
        passwordConfirmation: password.value,
        role: 'user',
        email: email.value.trim().isEmpty ? null : email.value.trim(),
        // fcmToken: fcm,
      );

      // Get.snackbar('تم', 'تم إنشاء الحساب وتسجيل الدخول');
      final fullPhoneUi = '${selected.value.dialCode} ${phoneLocal.value}';
      Get.to(() => const VerificationView(), binding: BindingsBuilder(() {
        Get.put(VerificationController());
      }), arguments: {'phone': fullPhoneUi});

    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  String _composeInternationalMsisdn(String dialCode, String local) {
    final cc = dialCode.replaceAll('+', '').trim();
    final nl = local.replaceAll(RegExp(r'\s+'), '');
    return '$cc$nl';
  }

  @override
  void onClose() {
    focusName.dispose(); focusPhone.dispose(); focusEmail.dispose(); focusPass.dispose();
    tosRecognizer.dispose(); privacyRecognizer.dispose();
    super.onClose();
  }
}
