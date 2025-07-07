import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/constants/constants.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/validator/validator.dart';
import '../../../verification/presentation/view/widget/code_verification.dart';
import '../controller/otp_register_controller.dart';

class OtpRegisterView extends StatelessWidget {
  OtpRegisterView({Key? key}) : super(key: key);

  final FieldValidator _validator = FieldValidator();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: SingleChildScrollView(
        child: GetBuilder<OtpRegisterController>(
          builder: (controller) {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: ManagerHeight.h110,
                      left: ManagerWidth.w16,
                      right: ManagerWidth.w16),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ManagerStrings.verify,
                          style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s24,
                              color: ManagerColors.primaryColor),
                        ),
                        SizedBox(
                          height: ManagerHeight.h8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ManagerStrings.resetSubTitle,
                              style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            mainButton(
                              onPressed: () {},
                              child: Text(
                                ManagerStrings.doYouWantToChangeIt,
                                style: getMediumTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.primaryColor,
                                ),
                              ),
                              height: ManagerHeight.h8,
                              padding: EdgeInsetsDirectional.only(
                                start: ManagerWidth.w2,
                              ),
                              color: ManagerColors.transparent,
                              elevation: 0.5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ManagerHeight.h28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ManagerStrings.verificationCode,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s16,
                                color: ManagerColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            mainButton(
                              onPressed: () {},
                              child: Text(
                                ManagerStrings.resendCode,
                                style: getMediumTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.grey,
                                ),
                              ),
                              height: ManagerHeight.h8,
                              padding: EdgeInsetsDirectional.only(
                                start: ManagerWidth.w2,
                              ),
                              color: ManagerColors.transparent,
                              elevation: 0.5
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ManagerHeight.h20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              CodeVerification(
                                controller: controller.firstCodeTextController,
                                focusNode: controller.firstFocusNode,
                                previousFocusNode: controller.firstFocusNode,
                                onChanged: (String value) {
                                  if (value.isNotEmpty) {
                                    controller.secondFocusNode.requestFocus();
                                  }
                                },
                                validator: (value) =>
                                    controller.validator.validateCode(value),
                              ),
                              SizedBox(
                                width: ManagerWidth.w10,
                              ),
                              CodeVerification(
                                controller: controller.secondCodeTextController,
                                focusNode: controller.secondFocusNode,
                                previousFocusNode: controller.firstFocusNode,
                                onChanged: (String value) {
                                  if (value.isNotEmpty) {
                                    controller.thirdFocusNode.requestFocus();
                                  } else {
                                    controller.firstFocusNode.requestFocus();
                                  }
                                },
                                validator: (value) =>
                                    controller.validator.validateCode(value),
                              ),
                              SizedBox(
                                width: ManagerWidth.w10,
                              ),
                              CodeVerification(
                                controller: controller.thirdCodeTextController,
                                focusNode: controller.thirdFocusNode,
                                previousFocusNode: controller.secondFocusNode,
                                onChanged: (String value) {
                                  if (value.isNotEmpty) {
                                    controller.fourthFocusNode.requestFocus();
                                  }
                                },
                                validator: (value) =>
                                    controller.validator.validateCode(value),
                              ),
                              SizedBox(
                                width: ManagerWidth.w10,
                              ),
                              CodeVerification(
                                controller: controller.fourthCodeTextController,
                                focusNode: controller.fourthFocusNode,
                                previousFocusNode: controller.thirdFocusNode,
                                onChanged: (String value) {
                                  if (value.isNotEmpty) {
                                    controller.fifthFocusNode.requestFocus();
                                  }
                                },
                                validator: (value) =>
                                    controller.validator.validateCode(value),
                              ),
                              SizedBox(
                                width: ManagerWidth.w10,
                              ),
                            ],
                          ),
                        ),
                        /*  SizedBox(
                          height: ManagerHeight.h28,
                        ),
                        textField(
                          hintText: ManagerStrings.password,
                          controller: controller.password,
                          validator: (value) => _validator.validatePassword(
                            value,
                          ),
                          textInputType: TextInputType.emailAddress,
                          focusNode: controller.seventhFocusNode,
                        ),
                        SizedBox(
                          height: ManagerHeight.h28,
                        ),
                        textField(
                          hintText: ManagerStrings.confirmPass,
                          controller: controller.confirmPassword,
                          validator: (value) => _validator.validatePassword(
                            value,
                          ),
                          textInputType: TextInputType.emailAddress,
                          focusNode: controller.eightFocusNode,
                        ),*/
                        SizedBox(
                          height: ManagerHeight.h28,
                        ),
                        SizedBox(
                          height: ManagerHeight.h48,
                          child: mainButton(
                            onPressed: () {
                              // if (controller.formKey.currentState!.validate()) {
                              // controller.otpRegister(context);
                              // }
                              Get.offNamed(Routes.options);
                            },
                            buttonName: ManagerStrings.next,
                            minWidth: double.infinity,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h10,
                        ),
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
