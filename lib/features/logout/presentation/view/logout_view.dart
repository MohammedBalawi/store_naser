import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/logout/domain/di/logout_di.dart';
import 'package:app_mobile/features/logout/presentation/controller/logout_controller.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';

class LogoutView extends StatefulWidget {
  const LogoutView({super.key});

  @override
  State<LogoutView> createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogoutController>(
      builder: (controller) {
        return Container(
          height: ManagerHeight.h300,
          color: ManagerColors.background,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ManagerStrings.logout,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                ),
                Text(
                  ManagerStrings.areYouSureLogout,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                SizedBox(
                  width: ManagerWidth.w300,
                  child: mainButton(
                    onPressed: () {
                      controller.logoutRequest();
                    },
                    buttonName: ManagerStrings.logout,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                SizedBox(
                  width: ManagerWidth.w300,
                  height: ManagerHeight.h48,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ManagerRadius.r12,
                        ),
                        border: Border.all(
                          color: ManagerColors.black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: ManagerHeight.h10,
                          right: ManagerHeight.h10,
                          top: ManagerHeight.h6,
                          bottom: ManagerHeight.h6,
                        ),
                        child: Center(
                          child: Text(
                            ManagerStrings.cancelCommand,
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    disposeLogout();
    super.dispose();
  }
}
