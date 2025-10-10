// lib/features/auth/presentation/controller/login_email_controller.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../verification/presentation/controller/verification_controller.dart';
import '../../../verification/presentation/view/verification_view.dart';

class GulfCountry {
  final String name;
  final String dialCode;
  final String flagAsset;
  final int minLen;
  const GulfCountry({
    required this.name,
    required this.dialCode,
    required this.flagAsset,
    required this.minLen,
  });
}

class LoginEmailController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final currentTabIndex = 0.obs;

  final phoneLocal = ''.obs;
  final email = ''.obs;
  final password = ''.obs;

  final phoneTouched = false.obs;
  final emailTouched = false.obs;
  final passTouched  = false.obs;

  final obscure = true.obs;
  void toggleObscure() => obscure.value = !obscure.value;

  late TabController tabController;

  final List<GulfCountry> gulfCountries = const [
    GulfCountry(name: 'المملكة العربية السعودية', dialCode: '+966', flagAsset: ManagerImages.su, minLen: 9),
    GulfCountry(name: 'الكويت',                dialCode: '+965', flagAsset: ManagerImages.kw, minLen: 8),
    GulfCountry(name: 'الإمارات العربية المتحدة', dialCode: '+971', flagAsset: ManagerImages.ae, minLen: 9),
    GulfCountry(name: 'البحرين',               dialCode: '+973', flagAsset: ManagerImages.bh, minLen: 8),
    GulfCountry(name: 'عمان',                  dialCode: '+968', flagAsset: ManagerImages.om, minLen: 8),
    GulfCountry(name: 'قطر',                   dialCode: '+974', flagAsset: ManagerImages.qa, minLen: 8),
  ];

  final Rx<GulfCountry> selected = const GulfCountry(
    name: 'المملكة العربية السعودية',
    dialCode: '+966',
    flagAsset: ManagerImages.su,
    minLen: 9,
  ).obs;

  bool get validPhone =>
      RegExp(r'^\d+$').hasMatch(phoneLocal.value) &&
          phoneLocal.value.length >= selected.value.minLen;

  bool get validEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.value.trim());

  bool get validPass => password.value.length >= 8;

  bool get canSubmit =>
      currentTabIndex.value == 0
          ? validPhone
          : (validEmail && validPass);

  String get phoneErrorText =>
      'أدخل رقمًا صالحًا (${selected.value.minLen}+ أرقام)';

  String? get emailErrorText =>
      !emailTouched.value || email.value.isEmpty || validEmail
          ? null
          : 'أدخل بريداً إلكترونياً صالحاً';

  String? get passErrorText =>
      !passTouched.value || password.value.isEmpty || validPass
          ? null
          : 'كلمة المرور التي أدخلتها غير صحيحة.';

  void onPhoneChanged(String v) {
    phoneLocal.value = v.replaceAll(' ', '');
    phoneTouched.value = true;
  }

  void onEmailChanged(String v) {
    email.value = v.trim();
    emailTouched.value = true;
  }

  void onPassChanged(String v) {
    password.value = v;
    passTouched.value = true;
  }

  void pickCountry(GulfCountry c) {
    selected.value = c;
    phoneLocal.refresh();
  }

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
  }

  void submit() {
    if (!canSubmit) return;

    if (currentTabIndex.value == 0) {
      final fullPhone = '${selected.value.dialCode} ${phoneLocal.value}';
      Get.to(() => const VerificationView(), binding: BindingsBuilder(() {
        Get.put(VerificationController());
      }), arguments: {'phone': fullPhone});
    } else {
    }
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
