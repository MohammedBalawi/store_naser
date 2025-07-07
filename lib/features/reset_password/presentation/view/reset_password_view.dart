import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icon_size.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/validator/validator.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);

  final FieldValidator _validator = FieldValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: SingleChildScrollView(
        child: GetBuilder<ResetPasswordController>(
          builder: (controller) {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: ManagerHeight.h110,
                    left: ManagerWidth.w16,
                    right: ManagerWidth.w16,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ManagerStrings.updatePassword,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s24,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        Text(
                          ManagerStrings.updatePasswordSubTitle,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ManagerHeight.h28),
                        SizedBox(height: ManagerHeight.h20),
                        Text(
                          ManagerStrings.password,
                          style: getRegularTextStyle(
                            fontSize: ManagerIconSize.s14,
                            color: ManagerColors.grey,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        textField(
                          hintText: ManagerStrings.password,
                          textInputType: TextInputType.text,
                          obSecure: controller.isObscurePassword,
                          suffixIcon: IconButton(
                            icon: controller.isObscurePassword
                                ? Icon(
                              ManagerIcons.visibilityOff,
                              color: ManagerColors.grey,
                            )
                                : Icon(
                              ManagerIcons.visibility,
                              color: ManagerColors.primaryColor,
                            ),
                            onPressed: () =>
                                controller.onChangeObscurePassword(),
                          ),
                          controller: controller.password,
                          validator: (value) => _validator.validatePassword(
                            value,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h40),
                        Text(
                          ManagerStrings.confirmPass,
                          style: getRegularTextStyle(
                            fontSize: ManagerIconSize.s14,
                            color: ManagerColors.grey,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        textField(
                          hintText: ManagerStrings.confirmPass,
                          textInputType: TextInputType.text,
                          obSecure: controller.isObscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: controller.isObscureConfirmPassword
                                ? Icon(
                              ManagerIcons.visibilityOff,
                              color: ManagerColors.grey,
                            )
                                : Icon(
                              ManagerIcons.visibility,
                              color: ManagerColors.primaryColor,
                            ),
                            onPressed: () =>
                                controller.onChangeObscureConfirmPassword(),
                          ),
                          controller: controller.confirmPassword,
                          validator: (value) => _validator.validatePassword(
                            value,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h28),
                        SizedBox(
                          height: ManagerHeight.h48,
                          child: mainButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.password.text !=
                                    controller.confirmPassword.text) {
                                  Get.snackbar(
                                    'خطأ',
                                    'كلمة المرور والتأكيد غير متطابقين',
                                  );
                                  return;
                                }

                                controller.resetPassword(
                                  controller.password.text,
                                );
                              }
                            },
                            buttonName: ManagerStrings.saveEdit,
                            minWidth: double.infinity,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h10),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
