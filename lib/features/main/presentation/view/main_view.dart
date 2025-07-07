import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/features/main/presentation/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/features/main/presentation/view/widget/drawer_view.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/widgets/pop_cope_widget.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return willPopScope(
      child: GetBuilder<MainController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: ManagerColors.white,
            key: controller.scaffoldKey,
            extendBody: true,
            drawer: DrawerView(),
            body: PersistentTabView(
              controller: controller.persistentTabController,
              backgroundColor: Colors.white,
              navBarBuilder: (navBarConfig) => Style1BottomNavBar(
                navBarConfig: navBarConfig,
              ),
              navBarHeight: ManagerHeight.h60,
              tabs: controller.bottomNavBarItems,
            ),
          );
        },
      ),
    );
  }
}
