import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_icons.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_styles.dart';
import '../resources/manager_width.dart';

void successToast({
  required String body,
}) {
  toastification.show(
    type: ToastificationType.success,
    context: Get.context!,
    showIcon: false,
    autoCloseDuration: const Duration(
      seconds: 2,
    ),
    title: Container(
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(
          ManagerRadius.r2,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ManagerWidth.w8,
              right: ManagerWidth.w8,
              top: ManagerHeight.h12,
              bottom: ManagerHeight.h12,
            ),
            child: Container(
              width: ManagerWidth.w60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ManagerColors.primaryColor,
              ),
              child: Icon(
                ManagerIcons.check,
                color: ManagerColors.white,
                size: ManagerWidth.w36,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: ManagerHeight.h8,
                bottom: ManagerHeight.h8,
              ),
              child: Text(
                body,
                style: getMediumTextStyle(
                  color: ManagerColors.primaryColor,
                  fontSize: ManagerFontSize.s18,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    ),
    showProgressBar: false,
  );
}
