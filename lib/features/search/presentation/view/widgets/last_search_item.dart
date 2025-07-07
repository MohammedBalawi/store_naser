import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

Widget lastSearchItem({
  required String title,
  required onTap,
  required onDeleteTap,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: ManagerHeight.h18,
      left: ManagerWidth.w10,
      bottom: ManagerHeight.h8,
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                ManagerIcons.clock,
                color: ManagerColors.grey,
              ),
              SizedBox(
                width: ManagerWidth.w10,
              ),
              Text(
                title,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.black,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onDeleteTap,
            child: Icon(
              ManagerIcons.close,
              color: ManagerColors.black,
            ),
          )
        ],
      ),
    ),
  );
}
