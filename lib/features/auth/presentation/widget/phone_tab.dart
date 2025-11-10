// lib/features/auth/presentation/widget/phone_field.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';
import '../controller/login_email_controller.dart';

class PhoneField extends GetView<LoginEmailController> {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    final anchorKey = GlobalKey();

    return Obx(() {
      // يعتمد على إضافاتك في الـController:
      // dialCodeDigits => "966"
      // fullMobileDigits => "966" + phoneLocal
      final dialDigits = controller.dialCodeDigits; // مثال: 966

      final showError = controller.phoneTouched.value &&
          controller.phoneLocal.value.isNotEmpty &&
          !controller.validPhone;
      final bool isArabic = Get.locale?.languageCode == 'ar';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: Row(
              children: [
                InkWell(
                  key: anchorKey,
                  onTap: () => controller.openCountryMenu(context, anchorKey),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(
                            controller.selected.value.flagAsset,
                            width: 28,
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$dialDigits+',
                          style: getBoldTextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: Colors.grey),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  child:
                  TextField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: controller.onPhoneChanged,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    textDirection:isArabic? TextDirection.ltr:TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: ManagerStrings.phone,
                      hintStyle:
                          getRegularTextStyle(fontSize: 16, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsetsDirectional.only(start: 12, end: 12),
                    ),
                    style:
                        getRegularTextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 8),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: showError ? 1 : 0,
            child: showError
                ? Row(
                    children: [
                      SvgPicture.asset(ManagerImages.warning),
                      const SizedBox(width: 6),
                      Text(
                        controller.phoneErrorText,
                        style: getRegularTextStyle(
                            fontSize: 13, color: Colors.red),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 6),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       'سيُرسل للخادم: ${controller.fullMobileDigits}', // مثال: 96655007710
          //       style: getRegularTextStyle(fontSize: 12, color: Colors.black54),
          //     ),
          //   ],
          // ),
        ],
      );
    });
  }
}
