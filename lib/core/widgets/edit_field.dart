import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_styles.dart';

Widget editFieldWidget({
  required String hint,
  String? title,
  required TextEditingController controller,
  required validator
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: ManagerHeight.h16,
      ),
      Text(
        title ?? hint,
        style: getRegularTextStyle(
          fontSize: ManagerFontSize.s14,
          color: ManagerColors.lightBlack,
        ),
      ),
      SizedBox(
        height: ManagerHeight.h10,
      ),
      textField(
        hintText: hint,
        controller: controller,
        validator: validator
      ),
    ],
  );
}
