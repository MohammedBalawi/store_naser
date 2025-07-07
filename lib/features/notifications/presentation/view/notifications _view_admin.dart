
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/features/notifications/presentation/controller/notifications_controller.dart';

import 'package:app_mobile/features/notifications/presentation/widgets/notification_item.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/text_field.dart';

class NotificationsAdminView extends StatefulWidget {
  const NotificationsAdminView({super.key});

  @override
  State<NotificationsAdminView> createState() => _NotificationsAdminViewState();
}

class _NotificationsAdminViewState extends State<NotificationsAdminView> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController());
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GetBuilder<NotificationsController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(title: ManagerStrings.notifications),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator(color: ManagerColors.primaryColor))
              : RefreshIndicator(
            onRefresh: () async => controller.notificationsRequest(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: ManagerColors.pink50,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.campaign, color: ManagerColors.primaryColor, size: width * 0.09),
                        SizedBox(width: width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ManagerStrings.welcomeTo,
                                style: getBoldTextStyle( fontSize: width * 0.045, color: ManagerColors.primaryColor)),
                            Text(ManagerStrings.welcomeSubTitle,
                                style: getBoldTextStyle(fontSize: width * 0.035, color: ManagerColors.primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  textField(
                    controller: titleController,
                    hintText: ManagerStrings.notificationsName,
                      textInputType: TextInputType.text,
                      obSecure: false,

                  ),
                  SizedBox(height: height * 0.015),
                  textField(
                    controller: bodyController,
                    maxLines: 3,
                    hintText: ManagerStrings.notificationsBody,
                    textInputType: TextInputType.text,
                    obSecure: false,
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        final body = bodyController.text.trim();
                        if (title.isNotEmpty && body.isNotEmpty) {
                          controller.sendNotification(title, body);
                          titleController.clear();
                          bodyController.clear();
                        } else {
                          Get.snackbar(ManagerStrings.error, ManagerStrings.failedUpdated,
                              backgroundColor:ManagerColors.red, colorText: ManagerColors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(ManagerStrings.sendNotification,
                          style: getMediumTextStyle(color: ManagerColors.white, fontSize: ManagerFontSize.s18)),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  SizedBox(height: height * 0.03),
                  ...controller.notifications.map((noti) => notificationsItem(model: noti)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
