import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/edit_field.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.white,
          appBar: mainAppBar(
            title: ManagerStrings.changePassword,
          ),
          body: ListView(
            children: [
              SvgPicture.asset(
                ManagerImages.changePassword,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w20,
                  vertical: ManagerHeight.h14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ManagerStrings.changePassword,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s26,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h16,
                    ),
                    Text(
                      ManagerStrings.changePasswordToContinue,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.grey,
                      ),
                    ),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          editFieldWidget(
                            hint: ManagerStrings.oldPassword,
                            controller: controller.oldPassword,
                            validator: (value) =>
                                controller.validator.validatePassword(value),
                          ),
                          editFieldWidget(
                            hint: ManagerStrings.newPassword,
                            title: ManagerStrings.newPassword,
                            controller: controller.newPassword,
                            validator: (value) =>
                                controller.validator.validatePassword(value),
                          ),
                          editFieldWidget(
                            hint: ManagerStrings.confirmNewPassword,
                            controller: controller.confirmPassword,
                            validator: (value) =>
                                controller.validator.confirmPassword(
                              value,
                              controller.newPassword.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: mainButton(
                            isLoading: controller.isLoading,
                            onPressed: () {
                              controller.performChangePassword();
                            },
                            child: Text(
                              ManagerStrings.saveEdit,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s18,
                                color: ManagerColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Get.delete<ChangePasswordController>();
    super.dispose();
  }
}
