import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../features/home/presentation/controller/home_controller.dart';
import '../../features/main/presentation/controller/main_controller.dart';
import '../../features/notifications/presentation/controller/notifications_controller.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_icon_size.dart';
import '../resources/manager_styles.dart';

PreferredSizeWidget homeAppBar({
  required String title,
}) {
  final homeController = Get.find<HomeController>();

  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(
      title,
      style: getBoldTextStyle(
        fontSize: ManagerFontSize.s18,
        color: ManagerColors.primaryColor,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        // Get.find<MainController>().openDrawer();
      },
      icon: SvgPicture.asset(ManagerImages.drawerIcon),
      iconSize: ManagerIconSize.s28,
    ),
    actions: [
      IconButton(
        onPressed: () {
          Get.find<MainController>().navigateToCart();
        },
        icon: SvgPicture.asset(
          ManagerImages.cartIcon,
        ),
        iconSize: ManagerIconSize.s20,
      ),
      Obx(
            () => IconButton(
          onPressed: () async {
            final NotificationsController controller =  Get.put(NotificationsController());

            await controller.notificationsRequest();
            await controller.markAllNotificationsAsRead();
            Get.find<MainController>().navigateToNotifications();
          },
          icon: SvgPicture.asset(
            homeController.hasNewNotification.value
                ? ManagerImages.notificationUnSeen
                : ManagerImages.notificationIcon,
          ),
          iconSize: ManagerIconSize.s20,
        ),
      ),
    ],
  );
}
