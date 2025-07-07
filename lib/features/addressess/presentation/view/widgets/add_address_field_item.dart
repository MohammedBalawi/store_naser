import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';

Widget addAddressFieldItem({
  required String title,
  required TextEditingController textController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          top: ManagerHeight.h14,
          bottom: ManagerHeight.h10,
        ),
        child: Text(
          title,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.grey,
          ),
        ),
      ),
      textField(
        hintText: title,
        controller: textController,
      ),
    ],
  );
}
