import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/orders/presentation/model/order_status_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';

Widget orderStatusItem({
  required OrderStatusModel model,
  required bool selected,
  required Function() onPressed,
}) {
  return Padding(
    padding: EdgeInsets.only(
      left: ManagerWidth.w10,
      right: ManagerWidth.w10,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ManagerRadius.r20,
        ),
        color: selected ? model.color : ManagerColors.transparent,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.only(
              top: ManagerWidth.w4,
              right: ManagerWidth.w10,
              left: ManagerWidth.w10,
              bottom: ManagerWidth.w4,
            ),
            child: Center(
              child: Text(
                model.title,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: selected ? ManagerColors.white : ManagerColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
