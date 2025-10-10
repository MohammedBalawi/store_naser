import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class SignUpController extends GetxController {
  final name = ''.obs;
  final phoneLocal = ''.obs;
  final email = ''.obs;
  final password = ''.obs;

  /// نعرض الأخطاء فقط بعد الضغط على "متابعة"
  final showErrors = false.obs;

  final List<GulfCountry> gulfCountries = [
    GulfCountry(
      name: 'المملكة العربية السعودية',
      dialCode: '+966',
      flagAsset: ManagerImages.su,
      minLen: 9,
    ),
    GulfCountry(
      name: 'الكويت',
      dialCode: '+965',
      flagAsset: ManagerImages.kw,
      minLen: 8,
    ),
    GulfCountry(
      name: 'الإمارات العربية المتحدة',
      dialCode: '+971',
      flagAsset: ManagerImages.ae,
      minLen: 9,
    ),
    GulfCountry(
      name: 'البحرين',
      dialCode: '+973',
      flagAsset: ManagerImages.bh,
      minLen: 8,
    ),
    GulfCountry(
      name: 'عمان',
      dialCode: '+968',
      flagAsset: ManagerImages.om,
      minLen: 8,
    ),
    GulfCountry(
      name: 'قطر',
      dialCode: '+974',
      flagAsset: ManagerImages.qa,
      minLen: 8,
    ),
  ];

  final Rx<GulfCountry> selected = GulfCountry(
    name: 'المملكة العربية السعودية',
    dialCode: '+966',
    flagAsset: ManagerImages.su,
    minLen: 9,
  ).obs;

  final obscure = true.obs;
  void toggleObscure() => obscure.value = !obscure.value;

  bool get validName => name.value.trim().isNotEmpty;

  bool get validPhone =>
      RegExp(r'^\d+$').hasMatch(phoneLocal.value) &&
          phoneLocal.value.length >= selected.value.minLen;

  bool get validEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.value.trim());

  bool get validPass => password.value.length >= 8;

  bool get canSubmit => validName && validPhone && validEmail && validPass;

  String get phoneErrorText =>
      'أدخل رقمًا صالحًا (${selected.value.minLen}+ أرقام)';

  void onPhoneChanged(String v) => phoneLocal.value = v.replaceAll(' ', '');

  void pickCountry(GulfCountry c) {
    selected.value = c;
    phoneLocal.refresh();
  }

  // فوكسات
  final focusName = FocusNode();
  final focusPhone = FocusNode();
  final focusEmail = FocusNode();
  final focusPass = FocusNode();

  final tosRecognizer = TapGestureRecognizer()..onTap = () {};
  final privacyRecognizer = TapGestureRecognizer()..onTap = () {};

  /// دالة زر "متابعة"
  void onSubmitPressed() {
    // أول ضغطة: فعّل عرض الأخطاء
    if (!showErrors.value) showErrors.value = true;

    if (canSubmit) {
      submit();
    } else {
      // ركّز على أول حقل خاطئ (اختياري)
      if (!validName) {
        FocusScope.of(Get.context!).requestFocus(focusName);
      } else if (!validPhone) {
        FocusScope.of(Get.context!).requestFocus(focusPhone);
      } else if (!validEmail) {
        FocusScope.of(Get.context!).requestFocus(focusEmail);
      } else if (!validPass) {
        FocusScope.of(Get.context!).requestFocus(focusPass);
      }
    }
  }

  Future<void> openCountryMenu(BuildContext context, GlobalKey anchorKey) async {
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final overlay =
    Overlay.of(context, rootOverlay: true).context.findRenderObject() as RenderBox;

    final buttonTopLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(
        buttonTopLeft.dx,
        buttonTopLeft.dy + box.size.height + 4,
        box.size.width,
        box.size.height,
      ),
      Offset.zero & overlay.size,
    );

    final menuWidth = _computeMenuWidth(context);

    final chosen = await showMenu<GulfCountry>(
      context: context,
      position: position,
      constraints: BoxConstraints.tightFor(width: menuWidth),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: _buildCountryItems(),
    );

    if (chosen != null) pickCountry(chosen);
  }

  double _computeMenuWidth(BuildContext context) {
    final longestCode =
    gulfCountries.map((e) => e.dialCode).reduce((a, b) => a.length >= b.length ? a : b);

    final style = getRegularTextStyle(fontSize: 16, color: Colors.black);
    final tp = TextPainter(
      text: TextSpan(text: longestCode, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final width = 10 + 24 + 8 + tp.width + 10 + 6;
    return width.clamp(120.0, 180.0);
  }

  List<PopupMenuEntry<GulfCountry>> _buildCountryItems() {
    final items = <PopupMenuEntry<GulfCountry>>[];
    for (var i = 0; i < gulfCountries.length; i++) {
      final item = gulfCountries[i];
      items.add(
        PopupMenuItem<GulfCountry>(
          value: item,
          height: 44,
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: i == 0
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.dialCode,
                    style: getRegularTextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(width: 8),
                Image.asset(
                  item.flagAsset,
                  width: 24,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  /// يكمل فقط لو البيانات صحيحة
  void submit() {
    final fullPhone = '${selected.value.dialCode} ${phoneLocal.value}';

    Get.to(
          () => const VerificationView(),
      binding: BindingsBuilder(() {
        Get.put(VerificationController());
      }),
      arguments: {'phone': fullPhone},
    );
  }

  @override
  void onClose() {
    focusName.dispose();
    focusPhone.dispose();
    focusEmail.dispose();
    focusPass.dispose();
    tosRecognizer.dispose();
    privacyRecognizer.dispose();
    super.onClose();
  }
}
