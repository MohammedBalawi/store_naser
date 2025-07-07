import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/scaffold_with_background.dart';

import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_width.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scaffoldWithImageBackground(
      child: Container(
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              ManagerImages.welcome,
              width: ManagerWidth.w350,
            ),
            Text(
              ManagerStrings.welcomeTo,
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s26, color: ManagerColors.black),
            ),
            Text(
              ManagerStrings.bubble,
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s26, color: ManagerColors.bubbleColor),
            ),
            Text(
              ManagerStrings.welcomeSubTitle,
              style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s20, color: ManagerColors.black),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
