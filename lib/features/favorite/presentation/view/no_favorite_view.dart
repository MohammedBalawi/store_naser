import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/features/favorite/presentation/controller/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';

class NoFavoriteView extends StatelessWidget {
  const NoFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(builder: (controller) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ManagerImages.noFavorite,
            ),
            SizedBox(
              height: ManagerHeight.h16,
            ),
            Text(
              ManagerStrings.emptySavedItems,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s22,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ManagerHeight.h14,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
              ),
              child: Text(
                ManagerStrings.pressFavoriteItemToAdd,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: ManagerColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: ManagerHeight.h24,
            ),
            mainButton(
              onPressed: () {
                controller.navigateToCategories();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w8,
                ),
                child: Text(
                  ManagerStrings.discoverCategories,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.white,
                  ),
                ),
              ),
              radius: ManagerRadius.r24,
            ),
            SizedBox(
              height: ManagerHeight.h60,
            ),
          ],
        ),
      );
    });
  }
}
