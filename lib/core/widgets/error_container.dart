import 'package:flutter/material.dart';
import '../../constants/constants/constants.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_styles.dart';

Container errorContainer(String message) {
  return Container(
    width: Constants.deviceWidth,
    height: Constants.deviceHeight,
    alignment: Alignment.center,
    padding: EdgeInsetsDirectional.only(
      bottom: ManagerHeight.h100,
    ),
    child: Text(
      message,
      style: getMediumTextStyle(
        fontSize: ManagerFontSize.s24,
        color: ManagerColors.grey,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
