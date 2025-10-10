// lib/features/auth/presentation/widget/phone_field.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';
import '../controller/login_email_controller.dart';

class PhoneField extends GetView<LoginEmailController> {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    final anchorKey = GlobalKey();
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
              Expanded(
                child:TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: controller.onPhoneChanged,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: "رقم الهاتف",
                    hintStyle: getRegularTextStyle(fontSize: 16, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsetsDirectional.only(start: 12, end: 12),
                  ),
                  style: getRegularTextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              InkWell(
                key: anchorKey,
                onTap: () => controller.openCountryMenu(context, anchorKey),
                borderRadius: BorderRadius.circular(10),
                child: Obx(() {
                  final c = controller.selected.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        // Container(width: 1, height: 28, color: const Color(0xFFEDEDED)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(c.dialCode, style: getBoldTextStyle(fontSize: 18, color: Colors.black)),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(c.flagAsset, width: 28, height: 18, fit: BoxFit.cover),
                        ),


                      ],
                    ),
                  );
                }),
              ),

            ],
          ),
        ),

        const SizedBox(height: 8),
        // Obx(() {
        //   final showError = controller.phoneTouched.value &&
        //       controller.phoneLocal.value.isNotEmpty &&
        //       !controller.validPhone;
        //   return AnimatedOpacity(
        //     duration: const Duration(milliseconds: 180),
        //     opacity: showError ? 1 : 0,
        //     child: showError
        //         ? Row(
        //       children: [
        //         const Icon(Icons.error_outline, color: Colors.red, size: 18),
        //         const SizedBox(width: 6),
        //         Text(
        //           controller.phoneErrorText,
        //           style: getRegularTextStyle(fontSize: 13, color: Colors.red),
        //         ),
        //       ],
        //     )
        //         : const SizedBox.shrink(),
        //   );
        // }),
      ],
    );
  }
}
