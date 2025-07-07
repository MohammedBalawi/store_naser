import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class NoSearchView extends StatelessWidget {
  const NoSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ManagerHeight.h60,
        ),
        Image.asset(
          ManagerImages.noSearch,
          width: ManagerWidth.w60,
        ),
        SizedBox(
          height: ManagerHeight.h20,
        ),
        Text(
          ManagerStrings.noAppropriateProducts,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.black,
          ),
        ),
        SizedBox(
          height: ManagerHeight.h20,
        ),
        Text(
          ManagerStrings.pleaseTryUseAppropriateWords,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
