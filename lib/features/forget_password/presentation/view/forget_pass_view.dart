import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/arrow_back_button.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:app_mobile/features/forget_password/presentation/controller/forget_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icon_size.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/validator/validator.dart';

class ForgetPassView extends StatelessWidget {
  ForgetPassView({super.key});

  final FieldValidator _validator = FieldValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.symmetric(
                vertical: ManagerHeight.h44,
                horizontal: ManagerWidth.w16,
              ),
              child: arrowBackButton(color: ManagerColors.primaryColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: GetBuilder<ForgetPasswordController>(
                builder: (controller) {
                  return Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ManagerStrings.resetPassword,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s26,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h8,
                        ),
                        Text(
                          ManagerStrings.forgetSubTitle,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.grey,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h90,
                        ),
                        Text(ManagerStrings.phone,
                            style: getRegularTextStyle(
                                fontSize: ManagerIconSize.s14,
                                color: ManagerColors.grey)),
                        SizedBox(
                          height: ManagerHeight.h8,
                        ),
                        textField(
                          prefixIcon: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ManagerHeight.h4,
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: ManagerColors.grey,
                                width: ManagerWidth.w1,
                              ),
                            )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.keyboard_arrow_down_sharp),
                                SizedBox(width: ManagerWidth.w8),
                                SvgPicture.asset(
                                  ManagerImages.flag,
                                  width: ManagerWidth.w18,
                                ),
                                SizedBox(width: ManagerWidth.w8),
                              ],
                            ),
                          ),
                          hintText: ManagerStrings.phone,
                          controller: controller.phone,
                          validator: (value) => _validator.validatePhoneNumber(
                            value,
                          ),
                          textInputType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: ManagerHeight.h28,
                        ),
                        SizedBox(
                          height: ManagerHeight.h40,
                          child: mainButton(
                              shapeDecoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 9),
                                  colors: [
                                    ManagerColors.primaryColor,
                                    ManagerColors.primaryColor.withOpacity(0)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ManagerRadius.r10,
                                  ),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: ManagerColors.primaryColorLight,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              onPressed: () {
                                // if (controller.formKey.currentState!
                                    // .validate()) {
                                  controller.forgetPassword(context);
                                // }
                              },
                              buttonName: ManagerStrings.confirm,
                              minWidth: double.infinity),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
