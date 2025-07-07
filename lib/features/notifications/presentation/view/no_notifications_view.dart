import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_strings.dart';
import 'package:app_mobile/features/notifications/presentation/controller/notifications_controller.dart';
class NoNotificationsView extends StatelessWidget {
  const NoNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ManagerImages.noNotifications,
              ),
              SizedBox(
                height: ManagerHeight.h16,
              ),
              Text(
                ManagerStrings.emptyNotifications,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s20,
                  color: ManagerColors.textColor,
                ),
              ),
              SizedBox(
                height: ManagerHeight.h20,
              ),
              mainButton(
                onPressed: () {
                },
                buttonName: ManagerStrings.discoverCategories
              ),
              SizedBox(
                height: ManagerHeight.h60,
              ),
            ],
          ),
        );
      }
    );
  }
}
