// lib/features/account_edit/presentation/view/change_phone_view.dart
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/change_phone_controller.dart';

class ChangePhoneView extends GetView<ChangePhoneController> {
  const ChangePhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final countryKey = GlobalKey();
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text(
                ManagerStrings.phoneNumber, style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      ManagerStrings.currentNumber, style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
                  const SizedBox(height: 6),
                  Obx(() => Text(controller.currentPhone.value,
                      style: getBoldTextStyle(color: ManagerColors.gray_3, fontSize: 12))),
                  const SizedBox(height: 16),

                  Text(
                      ManagerStrings.newNumber, style: getBoldTextStyle(color: Colors.black, fontSize: 12)),
                  const SizedBox(height: 8),

                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.hasError.value ? Colors.red : const Color(0xFFE9E9EF),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.phoneCtrl,
                              focusNode: controller.focusPhone,
                              keyboardType: TextInputType.number,
                              inputFormatters: controller.phoneFormatters,
                              decoration: InputDecoration(
                                hintText: ManagerStrings.phoneNumber,
                                hintStyle: getRegularTextStyle(fontSize: 16, color: ManagerColors.bongrey),
                                border: InputBorder.none,
                              ),
                              style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
                              onChanged: controller.onPhoneChanged,
                            ),
                          ),
                          const SizedBox(width: 12),

                          _CountryButton(key: countryKey),

                          if (controller.hasError.value) ...[
                            const SizedBox(width: 8),
                            SvgPicture.asset(ManagerImages.warning),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
        child: Obx(() {
          final enabled = controller.canSubmit.value;

          const activeColor = ManagerColors.color;
          const inactiveColor = ManagerColors.color_off;

          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.submit : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                backgroundColor: activeColor,
                disabledBackgroundColor: inactiveColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(ManagerStrings.update, style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

class _CountryButton extends StatelessWidget {
  const _CountryButton({super.key});

  static const double _flagW = 23.997657775878906;
  static const double _flagH = 18.0;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChangePhoneController>();

    return Obx(() {
      final sel = c.selected.value;
      return InkWell(
        key: (key as GlobalKey?),
        borderRadius: BorderRadius.circular(8),
        onTap: () => c.openCountryMenu(context, key as GlobalKey),
        child: Container(
          padding: const EdgeInsetsDirectional.only(start: 10, end: 8),
          height: 40,
          decoration: BoxDecoration(
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.keyboard_arrow_down, size: 18, color: ManagerColors.gray_3),
              const SizedBox(width: 4),
              Text(sel.dialCode,
                  style: getMediumTextStyle(fontSize: 16, color: ManagerColors.black)),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  sel.flagAsset,
                  width: _flagW,
                  height: _flagH,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
