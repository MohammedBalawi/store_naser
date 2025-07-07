import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:app_mobile/features/notifications/presentation/view/no_notifications_view.dart';
import 'package:app_mobile/features/notifications/presentation/widgets/notification_item.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../home/presentation/controller/home_controller.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationsController controller = Get.find<NotificationsController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.notifications,
            actions: [
              TextButton(
                onPressed: () async {
                  final NotificationsController controller = Get.find<NotificationsController>();
                  await controller.markAllNotificationsAsRead();
                  // لو حابب تحدث القائمة بعد ما يصيروا مقروء
                  await controller.notificationsRequest();
                },
                child: Text(
                  'See All',
                  style: getMediumTextStyle(
                    color: ManagerColors.primaryColor,
                    fontSize: ManagerFontSize.s14
                  ),
                ),
              ),
            ],

          ),
          body: controller.isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: ManagerColors.primaryColor,
              backgroundColor: ManagerColors.transparent,
            ),
          )
              : controller.notifications.isEmpty
              ? const NoNotificationsView()
              : RefreshIndicator(
            elevation: 0,
            color: ManagerColors.primaryColor,
            backgroundColor: ManagerColors.transparent,
            onRefresh: () async {
              controller.notificationsRequest();
            },
            child: ListView(
              padding: EdgeInsets.only(top: ManagerHeight.h20),
              children: controller.notifications
                  .map((n) => notificationsItem(model: n))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
