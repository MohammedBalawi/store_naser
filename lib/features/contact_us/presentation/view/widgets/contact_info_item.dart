import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/resources/manager_width.dart';

Widget contactInfoItem({required String image, required String value}) {
  return Column(
    children: [
      SvgPicture.asset(
        image,
        width: ManagerWidth.w30,
      ),
      SizedBox(
        height: ManagerHeight.h10,
      ),
      Text(
        value,
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s16,
          color: ManagerColors.white,
        ),
      ),
    ],
  );
}
