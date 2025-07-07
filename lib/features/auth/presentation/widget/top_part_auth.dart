import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/resources/manager_images.dart';

Expanded partTopAuth() {
  return Expanded(
    flex: 1,
    child: Center(
      child: SvgPicture.asset(
        ManagerImages.logo,
        colorFilter: const ColorFilter.mode(
          ManagerColors.background,
          BlendMode.darken,
        ),
      ),
    ),
  );
}
