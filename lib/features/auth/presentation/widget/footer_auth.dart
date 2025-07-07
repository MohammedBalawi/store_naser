import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';

class FooterAuth extends StatelessWidget {
  final String text;
  final String buttonName;
  final Function() onPressed;

  const FooterAuth({
    super.key,
    required this.text,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ManagerHeight.h28,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.textColorLight,
              ),
            ),
            Text(
              buttonName,
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s14,
                decoration: TextDecoration.underline,
                color: ManagerColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
