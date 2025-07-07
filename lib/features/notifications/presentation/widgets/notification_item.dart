import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/notifications/domain/models/notification_model.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_width.dart';

Widget notificationsItem({
  required NotificationModel model,

}) {
  return Padding(
    padding: EdgeInsets.only(
      right: ManagerWidth.w20,
      left: ManagerWidth.w20,
      top: ManagerHeight.h20,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ManagerRadius.r6,
        ),
        color: ManagerColors.notificationsBackground,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ManagerWidth.w10,
              right: ManagerWidth.w10,
            ),
            child: SvgPicture.asset(
              model.isRead!
                  ? ManagerImages.notificationSeen
                  : ManagerImages.notificationUnSeen,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                ManagerWidth.w10,
              ),
              child: Text(
                model.description,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.black,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
