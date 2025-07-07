import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../libs/rating/rating.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_styles.dart';
import '../resources/manager_width.dart';

Widget assessmentTile({
  required String image,
  required int rate,
  required String comment,
  required String name,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: ManagerHeight.h12,
      left: ManagerHeight.h4,
      right: ManagerHeight.h4,
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    ManagerHeight.h10,
                  ),
                  child: profileAvatar(
                    image: image,
                    radius: ManagerRadius.r20,
                  ),
                ),
                // Adding Starts
                Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h10,),
                    SizedBox(
                      width: ManagerWidth.w150,
                      child: Text(
                        name,
                        textAlign: TextAlign.right,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.black,
                        ),
                      ),
                    ),
                    RatingBar(
                      itemSize: ManagerWidth.w16,
                      ignoreGestures: true,
                      itemPadding: EdgeInsets.all(ManagerHeight.h2,),
                      initialRating: rate.toDouble(),
                      minRating: Constants.minRating,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(
                          ManagerImages.filledStar,
                        ),
                        half: SvgPicture.asset(
                          ManagerImages.filledStar,
                        ),
                        empty: SvgPicture.asset(
                          ManagerImages.emptyStar,
                        ),
                      ),
                      onRatingUpdate: (value) {},
                      allowHalfRating: false,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, box) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ManagerHeight.h4,
                  ),
                  child: SizedBox(
                    width: box.maxWidth - ManagerWidth.w20,
                    child: Text(
                      comment,
                      textDirection: TextDirection.rtl,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    ),
  );
}
