import 'package:flutter/material.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_styles.dart';

PreferredSizeWidget mainAppBar({
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    centerTitle: true,
    shadowColor: ManagerColors.appBarShadow,
    elevation: 0.8,
    backgroundColor: ManagerColors.white,
    title: Text(
      title,
      style: getMediumTextStyle(
        fontSize: ManagerFontSize.s18,
        color: ManagerColors.primaryColor,
      ),
    ),
    actions: actions,
  );
}
