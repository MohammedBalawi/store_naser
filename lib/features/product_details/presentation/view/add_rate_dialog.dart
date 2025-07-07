import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/libs/rating/rating.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';

Widget addRateDialog({required double rate}){
  return Column(
    children: [
      Text(
        ManagerStrings.assessmentAdded,
        style: getBoldTextStyle(
          fontSize: ManagerFontSize.s20,
          color: Colors.black
        ),
      ),
      SizedBox(
        height: ManagerHeight.h14,
      ),
      Text(
        ManagerStrings.thanksForAssessment,
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s18,
          color: ManagerColors.blackAccent,
        ),
      ),
      SizedBox(
        height: ManagerHeight.h14,
      ),
      RatingBar(
        itemSize: ManagerWidth.w30,
        ignoreGestures: true,
        itemPadding: EdgeInsets.all(
          ManagerHeight.h2,
        ),
        initialRating: rate,
        minRating: 1,
        ratingWidget: RatingWidget(
          full: SvgPicture.asset(
            ManagerImages.filledStar,
            width: ManagerWidth.w120,
            height: ManagerWidth.w120,
          ),
          half: SvgPicture.asset(
            ManagerImages.filledStar,
            width: ManagerWidth.w120,
            height: ManagerWidth.w120,
          ),
          empty: SvgPicture.asset(
            ManagerImages.emptyStar,
            width: ManagerWidth.w120,
            height: ManagerWidth.w120,
          ),
        ),
        onRatingUpdate: (value) {},
        allowHalfRating: false,
      ),
      SizedBox(
        height: ManagerHeight.h30,
      ),
    ],
  );
}