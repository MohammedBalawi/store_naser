// lib/features/account_edit/presentation/controller/change_phone_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';

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

class ChangePhoneController extends GetxController {
  final currentPhone = '+966 515345678'.obs;

  final List<GulfCountry> gulfCountries = const [
    GulfCountry(name: 'المملكة العربية السعودية', dialCode: '+966', flagAsset: ManagerImages.su, minLen: 9),
    GulfCountry(name: 'الكويت',                 dialCode: '+965', flagAsset: ManagerImages.kw, minLen: 8),
    GulfCountry(name: 'الإمارات العربية المتحدة', dialCode: '+971', flagAsset: ManagerImages.ae, minLen: 9),
    GulfCountry(name: 'البحرين',                dialCode: '+973', flagAsset: ManagerImages.bh, minLen: 8),
    GulfCountry(name: 'عُمان',                  dialCode: '+968', flagAsset: ManagerImages.om, minLen: 8),
    GulfCountry(name: 'قطر',                    dialCode: '+974', flagAsset: ManagerImages.qa, minLen: 8),
  ];

  final Rx<GulfCountry> selected = const GulfCountry(
    name: 'المملكة العربية السعودية',
    dialCode: '+966',
    flagAsset: ManagerImages.su,
    minLen: 9,
  ).obs;

  final phoneCtrl = TextEditingController();
  final focusPhone = FocusNode();

  final hasError = false.obs;
  final canSubmit = false.obs;

  List<TextInputFormatter> get phoneFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(selected.value.minLen),
  ];

  bool get validLocal {
    final v = phoneCtrl.text.trim();
    return RegExp(r'^[0-9]+$').hasMatch(v) && v.length == selected.value.minLen;
  }

  String get fullNewPhone => '${selected.value.dialCode} ${phoneCtrl.text.trim()}';

  void onPhoneChanged(String _) {
    hasError.value = false;
    canSubmit.value = validLocal;
  }

  Future<void> openCountryMenu(BuildContext context, GlobalKey anchorKey) async {
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);

    const flagW = 23.997657775878906;
    const flagH = 18.0;
    final itemTextStyle = getRegularTextStyle(fontSize: 16, color: Colors.black);

    final picked = await showMenu<GulfCountry>(
      context: context,
      position: RelativeRect.fromLTRB(rect.left, rect.bottom + 6, rect.right, 0),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Colors.white, width: 0), // بدون إطار
      ),
      items: [
        for (int i = 0; i < gulfCountries.length; i++)
          PopupMenuItem<GulfCountry>(
            value: gulfCountries[i],
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Text(
                  gulfCountries[i].dialCode,
                  style: itemTextStyle,
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    gulfCountries[i].flagAsset,
                    width: flagW,
                    height: flagH,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    if (picked != null) {
      selected.value = picked;

      final t = phoneCtrl.text;
      if (t.length > picked.minLen) {
        phoneCtrl.text = t.substring(0, picked.minLen);
        phoneCtrl.selection = TextSelection.collapsed(offset: phoneCtrl.text.length);
      }
      onPhoneChanged(phoneCtrl.text);
      Future.microtask(() => focusPhone.requestFocus());
    }
  }


  void submit() {
    if (!validLocal) {
      hasError.value = true;
      canSubmit.value = false;
      return;
    }

    if (fullNewPhone == currentPhone.value) {
      hasError.value = true;
      canSubmit.value = false;

      Get.rawSnackbar(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        messageText: Row(
          children: [
            Expanded(
              child: Text('رقم هاتفك قيد الاستخدام بالفعل',
                  textAlign: TextAlign.right,
                  style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(ManagerImages.wallet),
          ],
        ),
      );
      return;
    }

    Get.toNamed(Routes.phoneOtp, arguments: {'phone': fullNewPhone});
  }

  void applySuccessAndReset(String newFullPhone) {
    currentPhone.value = newFullPhone;
    phoneCtrl.clear();
    canSubmit.value = false;
    hasError.value = false;

    Get.rawSnackbar(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      messageText: Row(
        children: [
          Expanded(
            child: Text('لقد تم تغيير رقم هاتفك بنجاح.',
                textAlign: TextAlign.right,
                style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, color: ManagerColors.like),
        ],
      ),
    );
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    focusPhone.dispose();
    super.onClose();
  }
}
