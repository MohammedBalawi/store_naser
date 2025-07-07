import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';

Widget termItem({
  required String title,
  required String body,
}) {
  return Padding(
    padding: EdgeInsets.all(
      ManagerHeight.h16,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s18,
            color: ManagerColors.black,
          ),
        ),
        SizedBox(
          height: ManagerHeight.h10,
        ),
        Text(
          body,
        )
      ],
    ),
  );
}
