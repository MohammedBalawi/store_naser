import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/core/widgets/scaffold_with_background.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_width.dart';

class DoneResetPassView extends StatelessWidget {
  const DoneResetPassView({super.key});

  @override
  Widget build(BuildContext context) {
    return scaffoldWithImageBackground(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: Container(
          child: Column(
            children: [
              Image.asset(
                ManagerImages.doneResetPass,
                width: ManagerWidth.w350,
              ),
              Text(
                ManagerStrings.youAreDone,
                style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s26, color: ManagerColors.black),
              ),
              SizedBox(height: ManagerHeight.h8),
              Text(
                ManagerStrings.yourPasswordHasBeenChangedSuccessfully,
                style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s20, color: ManagerColors.black),
              ),
              SizedBox(
                height: ManagerHeight.h28,
              ),
              Spacer(),
              SizedBox(
                height: ManagerHeight.h48,
                child: mainButton(
                  onPressed: () {
                    // if (controller.formKey.currentState!.validate()) {
        
                    // }
                    
                  },
                  buttonName: ManagerStrings.goToHome,
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
    );
  }
}
