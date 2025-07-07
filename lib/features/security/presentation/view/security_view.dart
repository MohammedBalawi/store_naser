import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/security/presentation/view/widgets/security_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_height.dart';
import '../controller/securiy_controller.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecurityController>(
      init: SecurityController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.white,
          appBar: mainAppBar(
            title: ManagerStrings.securitySettings,
          ),
          body: Padding(
            padding: EdgeInsets.all(
              ManagerHeight.h20,
            ),
            child: ListView(
              children: [
                CircleAvatar(
                  radius: ManagerRadius.r30,
                  backgroundColor: ManagerColors.greyAccent.withOpacity(
                    ManagerOpacity.op0_1,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ManagerHeight.h8,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        ManagerImages.security,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h6,
                ),
                Center(
                  child: Text(
                    ManagerStrings.securitySettings,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s18,
                      color: ManagerColors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h40,
                ),
                InkWell(
                  onTap: () {
                    controller.navigateToEditPassword();
                  },
                  child: securityItem(
                    title: ManagerStrings.changePassword,
                    body: ManagerStrings.changePasswordToContinue,
                    child: Icon(
                      ManagerIcons.arrowIos,
                    ),
                    status: true,
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
    Get.delete<SecurityController>();
    super.dispose();
  }
}
