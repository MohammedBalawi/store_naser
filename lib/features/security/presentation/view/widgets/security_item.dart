import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/divider.dart';
import 'package:flutter/material.dart';

Widget securityItem({
  required String title,
  required String body,
  Widget? child,
  bool? status,
  onChangeSwitch,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s18,
              color: ManagerColors.black,
            ),
          ),
          child??Switch(
            value: status ?? false,
            onChanged: onChangeSwitch ?? (value) {},
            activeColor: ManagerColors.white,
            activeTrackColor: ManagerColors.blueAccent,
            inactiveTrackColor: ManagerColors.greyLight.withOpacity(ManagerOpacity.op0_2),
          ),
        ],
      ),
      SizedBox(
        height: ManagerHeight.h10,
      ),
      Text(
        body,
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s15,
          color: ManagerColors.black,
        ),
      ),
      SizedBox(
        height: ManagerHeight.h6,
      ),
      divider(),
    ],
  );
}
