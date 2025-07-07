
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/main/presentation/controller/main_controller.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icon_size.dart';
import '../../../../../core/resources/manager_width.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../home/presentation/controller/home_controller.dart';
import '../../../../profile/presentation/controller/profile_controller.dart';

class DrawerView extends StatelessWidget {
  Map<String, dynamic>? currentUser;
  final supabase = Supabase.instance.client;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      return Drawer(
        width: ManagerWidth.w288,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: ManagerHeight.h50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ManagerImages.logo_refresh,
                  width: ManagerWidth.w76,
                  height: ManagerHeight.h50,
                ),
                SizedBox(
                  width: ManagerWidth.w9 ,
                ),
                Text(
                  ManagerStrings.worldOfShopping,
                  style: getMediumTextStyle(
                      fontSize:  ManagerIconSize.s16,
                      color: ManagerColors.primaryColor),
                )
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: ManagerWidth.w16),
              child: Column(
                children: [
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerCartIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.myOrders,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToOrders();
                    },
                  ),
                  GetBuilder<HomeController>(
                    builder: (controller) {
                      return FutureBuilder<bool>(
                        future: controller.checkIfAdmin(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!) {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: const Icon(
                              Icons.admin_panel_settings_outlined,
                              color: ManagerColors.subTitleColor,
                            ),
                            title: Text(
                              ManagerStrings.userManagement,
                              style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.primaryColor),
                            ),
                            onTap: () {
                              controller.navigateToUserManagement();
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  GetBuilder<HomeController>(
                    builder: (controller) {
                      return FutureBuilder<bool>(
                        future: controller.checkIfAdmin(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!) {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: SvgPicture.asset(
                              ManagerImages.notification2,
                              width: ManagerWidth.w22,
                            ),
                            title: Text(
                              ManagerStrings.notifications,
                              style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.primaryColor),
                            ),
                            onTap: () {
                              controller.navigateToNotification();
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerLocationIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.address,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToAddresses();
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  GetBuilder<HomeController>(
                    builder: (controller) {
                      return FutureBuilder<bool>(
                        future: controller.checkIfAdmin(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!) {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: const Icon(
                              Icons.table_rows_outlined,
                              color: ManagerColors.subTitleColor,
                            ),
                            // SvgPicture.asset(
                            //   ManagerImages.doneResetPass,
                            //   width: ManagerWidth.w22,
                            // ),
                            title: Text(
                              ManagerStrings.tables,
                              style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.primaryColor),
                            ),
                            onTap: () {
                              controller.navigateToActivity();
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerSupportIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.support,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToContactUs();
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.security,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.securitySettings,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToSecurity();
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h8,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerPolicyIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.privacyPolicy,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    onTap: () {
                      controller.navigateToTerms();
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h30,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerDeleteIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.deleteAccount,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToDeleteAccount(
                        context: context,
                      );
                    },
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      ManagerImages.drawerLogoutIcon,
                      width: ManagerWidth.w22,
                    ),
                    title: Text(
                      ManagerStrings.logout,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor),
                    ),
                    onTap: () {
                      controller.navigateToLogout(
                        context: context,
                      );
                    },
                  ),
                  SizedBox(
                    height: ManagerHeight.h30,
                  ),
                  Row(
                    children: [
                      GetBuilder<ProfileController>(
                        builder: (controller) {
                          final imageProvider =
                              (controller.profileImageUrl != null &&
                                      controller.profileImageUrl!.isNotEmpty)
                                  ? NetworkImage(controller.profileImageUrl!)
                                  : const AssetImage(ManagerImages.logo_refresh)
                                      as ImageProvider;

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.editProfile);
                            },
                            child: Container(
                              width: ManagerWidth.w40,
                              height: ManagerHeight.h40,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(7000),
                                ),
                              ),
                              child: Container(
                                width: ManagerWidth.w40,
                                height: ManagerHeight.h40,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: ManagerWidth.w8,
                      ),
                      GetBuilder<ProfileController>(
                        init: ProfileController(),
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.name,
                                style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s14,
                                    color: ManagerColors.primaryColor),
                              ),
                              Text(
                                controller.email,
                                style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s12,
                                    color: ManagerColors.grey),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
