import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icon_size.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';

Widget orderStepItem({
  required bool enabled,
  required IconData icon,
  required String title,
}) {
  return Column(
    children: [
      Text(
        title,
        style: getRegularTextStyle(
          fontSize: ManagerFontSize.s14,
          color: ManagerColors.green,
        ),
      ),
      Row(
        children: [
          Container(
            height: ManagerHeight.h10,
            width: ManagerWidth.w68,
            color: enabled ? ManagerColors.green : ManagerColors.grey,
          ),
          CircleAvatar(
            radius: ManagerRadius.r16,
            backgroundColor: enabled ? ManagerColors.green : ManagerColors.grey,
            child: Icon(
              icon,
              color: ManagerColors.white,
              size: ManagerIconSize.s18,
            ),
          ),
        ],
      ),
    ],
  );
}
