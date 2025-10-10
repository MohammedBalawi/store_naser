// lib/features/account_edit/presentation/view/change_phone_view.dart
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
    // مفتاح للزر حتى نعلّق عليه المنيو بدقة
    final countryKey = GlobalKey();

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
            Text('رقم الهاتف', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
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

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الرقم الحالي
                Text('الرقم الحالي', style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 6),
                Obx(() => Text(controller.currentPhone.value,
                    style: getBoldTextStyle(color: ManagerColors.gray_3, fontSize: 12))),
                const SizedBox(height: 16),

                // الرقم الجديد
                Text('الرقم الجديد', style: getBoldTextStyle(color: Colors.black, fontSize: 12)),
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
                        // حقل الرقم
                        Expanded(
                          child: TextField(
                            controller: controller.phoneCtrl,
                            focusNode: controller.focusPhone,
                            keyboardType: TextInputType.number,
                            inputFormatters: controller.phoneFormatters,
                            decoration: InputDecoration(
                              hintText: 'رقم الهاتف',
                              hintStyle: getRegularTextStyle(fontSize: 16, color: ManagerColors.bongrey),
                              border: InputBorder.none,
                            ),
                            style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
                            onChanged: controller.onPhoneChanged,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // زر الدولة (العلم 23.997657775878906 × 18 والنص 16)
                        _CountryButton(key: countryKey),

                        // أيقونة خطأ عند الحاجة
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
              child: Text('تحديث', style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

/// زر اختيار الدولة مطابق للصورة
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
