import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/widgets/pop_cope_widget.dart';
import '../controller/main_controller.dart';
// import 'widget/drawer_view.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  static const Color _darkBg = Color(0xFF0E0F12);

  @override
  Widget build(BuildContext context) {
    return willPopScope(
      child: Obx(() {
        final isReels = controller.isReels;

        final navBg = isReels ? _darkBg : Colors.white;
        final overlay =
        isReels ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: Scaffold(
            key: controller.scaffoldKey,
            extendBody: true,
            backgroundColor: navBg,
            body: PersistentTabView(
              controller: controller.persistentTabController,
              backgroundColor: navBg,
              navBarHeight: ManagerHeight.h60,
              navBarBuilder: (navBarConfig) => isReels
                  ? _BlackNavBar(navBarConfig: navBarConfig)
                  : Style1BottomNavBar(navBarConfig: navBarConfig),
              tabs: controller.bottomNavBarItems,
            ),
          ),
        );
      }),
    );
  }
}

class _BlackNavBar extends StatelessWidget {
  const _BlackNavBar({required this.navBarConfig});

  final NavBarConfig navBarConfig;

  static const Color darkBg = Color(0xFF0E0F12);

  @override
  Widget build(BuildContext context) {
    final items = navBarConfig.items;
    final selected = navBarConfig.selectedIndex;

    return ColoredBox(
      color: darkBg,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: navBarConfig.navBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final bool active = i == selected;
              final icon =
              active ? item.icon : (item.inactiveIcon ?? item.icon);

              final textColor = active
                  ? ManagerColors.color
                  : ManagerColors.white;

              return Expanded(
                child: InkWell(
                  onTap: () => navBarConfig.onItemSelected(i),
                  splashColor: Colors.white10,
                  highlightColor: Colors.white10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(height: 6),
                      if (item.title != null)
                        Text(
                          item.title!,
                          style: item.textStyle?.copyWith(color: textColor),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
