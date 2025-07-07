import 'package:flutter/material.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';

Widget quantityControlContainer({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(ManagerHeight.h25 / 2),
    child: Container(
      width: ManagerWidth.w32,
      height: ManagerHeight.h32,
      decoration: BoxDecoration(
        color: ManagerColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: ManagerColors.primaryColor.withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: ManagerColors.primaryColor,
          size: ManagerHeight.h18,
        ),
      ),
    ),
  );
}
