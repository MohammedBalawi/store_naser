import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_height.dart';
import '../resources/manager_opacity.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_width.dart';

Container customServiceIcon(
    {required String image, double? width, double? height}) {
  return Container(
    width: width ?? ManagerWidth.w32,
    height: height ?? ManagerHeight.h32,
    padding: EdgeInsets.symmetric(
      horizontal: ManagerWidth.w4,
      vertical: ManagerHeight.h4,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        ManagerRadius.r10,
      ),
      color: ManagerColors.primaryColor.withOpacity(
        ManagerOpacity.op0_5,
      ),
    ),
    child: SvgPicture.asset(image),
  );
}
