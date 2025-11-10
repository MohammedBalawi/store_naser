// lib/features/auth/presentation/view/controller/login_email_controller.dart
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../data/auth_api.dart';

class GulfCountry {
  final String name;
  final String dialCode;     // مثل: +966
  final String flagAsset;
  final int minLen;          // الحد الأدنى للأرقام المحلية
  const GulfCountry({
    required this.name,
    required this.dialCode,
    required this.flagAsset,
    required this.minLen,
  });
}

class LoginEmailController extends GetxController with GetSingleTickerProviderStateMixin {
  final currentTabIndex = 0.obs;

  final phoneLocal = ''.obs;   // بدون المقدّمة
  final email = ''.obs;
  final password = ''.obs;

  final phoneTouched = false.obs;
  final emailTouched = false.obs;
  final passTouched  = false.obs;

  final obscure = true.obs;
  void toggleObscure() => obscure.value = !obscure.value;

  final isLoading = false.obs;
  String? serverError;

  late TabController tabController;

  final List<GulfCountry> gulfCountries = const [
    GulfCountry(name: 'المملكة العربية السعودية', dialCode: '+966', flagAsset: ManagerImages.su, minLen: 7),
    GulfCountry(name: 'الكويت', dialCode: '+965', flagAsset: ManagerImages.kw, minLen: 7), // كان 8
    GulfCountry(name: 'الإمارات العربية المتحدة', dialCode: '+971', flagAsset: ManagerImages.ae, minLen: 7),
    GulfCountry(name: 'البحرين', dialCode: '+973', flagAsset: ManagerImages.bh, minLen: 7),
    GulfCountry(name: 'عمان', dialCode: '+968', flagAsset: ManagerImages.om, minLen: 7),
    GulfCountry(name: 'قطر', dialCode: '+974', flagAsset: ManagerImages.qa, minLen: 7),
  ];

  final Rx<GulfCountry> selected = const GulfCountry(
    name: 'المملكة العربية السعودية',
    dialCode: '+966',
    flagAsset: ManagerImages.su,
    minLen: 9,
  ).obs;

  String get dialCodeDigits => selected.value.dialCode.replaceAll('+', '');

  String get fullMobileDigits => '$dialCodeDigits${phoneLocal.value}';

  String get fullMobileE164 => '+$fullMobileDigits';
  bool get validPhone {
    final local = phoneLocal.value;
    final onlyDigits = RegExp(r'^\d+$').hasMatch(local);
    final fullLen = local.length + dialCodeDigits.length;
    return onlyDigits && (local.length >= selected.value.minLen || fullLen == 10);
  }


  bool get validEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.value.trim());

  bool get validPass => password.value.length >= 8;

  bool get canSubmit =>
      currentTabIndex.value == 0 ? validPhone : (validEmail && validPass);

  String get phoneErrorText => '${ManagerStrings.enterValidNumber} (${selected.value.minLen}+ أرقام)';
  String? get emailErrorText =>
      !emailTouched.value || email.value.isEmpty || validEmail ? null : 'أدخل بريداً إلكترونياً صالحاً';
  String? get passErrorText =>
      !passTouched.value || password.value.isEmpty || validPass ? null : 'كلمة المرور التي أدخلتها غير صحيحة.';

  void onPhoneChanged(String v) { phoneLocal.value = v.replaceAll(' ', ''); phoneTouched.value = true; }
  void onEmailChanged(String v) { email.value = v.trim(); emailTouched.value = true; }
  void onPassChanged(String v)  { password.value = v; passTouched.value = true; }

  void pickCountry(GulfCountry c) { selected.value = c; phoneLocal.refresh(); }

  Future<void> openCountryMenu(BuildContext context, GlobalKey anchorKey) async {
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context, rootOverlay: true).context.findRenderObject() as RenderBox;
    final buttonTopLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(buttonTopLeft.dx, buttonTopLeft.dy + box.size.height + 4, box.size.width, box.size.height),
      Offset.zero & overlay.size,
    );

    final chosen = await showMenu<GulfCountry>(
      context: context,
      position: position,
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      constraints: const BoxConstraints.tightFor(width: 160),
      items: gulfCountries.map((item) {
        return PopupMenuItem<GulfCountry>(
          value: item,
          height: 44,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(item.flagAsset, width: 24, height: 16, fit: BoxFit.cover),
              const SizedBox(width: 8),
              Text(item.dialCode, style: getRegularTextStyle(fontSize: 16, color: Colors.black)),
            ]),
          ),
        );
      }).toList(),
    );

    if (chosen != null) pickCountry(chosen);
  }

  void onTabChanged(int i) {
    currentTabIndex.value = i;
    emailTouched.value = false;
    passTouched.value  = false;
    phoneTouched.value = false;
    serverError = null;
  }

  void _showResultToast({required bool ok, required String message}) {
    Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      margin: EdgeInsets.only(left: Get.width * 0.1, right: Get.width * 0.1, top: Get.height * 0.02),
      borderRadius: 12,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      boxShadows: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ok?
          Icon(Icons.check_circle , color: ManagerColors.like , size: 20):
         SvgPicture.asset(ManagerImages.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, textAlign: TextAlign.right, style: getMediumTextStyle(fontSize: 12, color: Colors.black), maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Future<void> submit() async {
    if (!canSubmit || isLoading.value) return;
    isLoading.value = true;
    serverError = null;

    try {
      if (currentTabIndex.value == 0) {
        final res = await AuthApi.loginWithMobile(
          mobile: fullMobileDigits,
          password: password.value,
        );
        if (res.ok) {
          await _persistToken(res.token!);
          _showResultToast(ok: true, message: ManagerStrings.loginSuccess);
        } else {
          serverError = res.message ?? 'تعذّر تسجيل الدخول. تحقق من الرقم أو كلمة المرور.';
          _showResultToast(ok: false, message: serverError!);
        }
      } else {
        final res = await AuthApi.loginWithEmail(email: email.value, password: password.value);
        if (res.ok) {
          await _persistToken(res.token!);
          _showResultToast(ok: true, message: ManagerStrings.loginSuccess);
        } else {
          serverError = res.message ?? 'تعذّر تسجيل الدخول. تحقق من البريد أو كلمة المرور.';
          _showResultToast(ok: false, message: serverError!);
        }
      }
    } catch (_) {
      serverError = ManagerStrings.serverConnectionProblem;
      _showResultToast(ok: false, message: serverError!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persistToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('access_token', token);
  }

  final focusPhone = FocusNode();
  final focusEmail = FocusNode();
  final focusPass  = FocusNode();

  final tosRecognizer = TapGestureRecognizer()..onTap = () {};
  final privacyRecognizer = TapGestureRecognizer()..onTap = () {};

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this)..addListener(() {
      if (tabController.indexIsChanging) onTabChanged(tabController.index);
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    focusPhone.dispose();
    focusEmail.dispose();
    focusPass.dispose();
    tosRecognizer.dispose();
    privacyRecognizer.dispose();
    super.onClose();
  }
}
