import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import '../resources/manager_font_size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;

  CustomAppBar({required this.title, this.hasLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ManagerColors.transparent,
      elevation: 0.5,
      title: Text(
        title,
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s18,
          color: ManagerColors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );
}
