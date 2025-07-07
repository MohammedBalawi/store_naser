import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_product_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_width.dart';

Widget orderProductItem({
  required FinishedOrderProductModel model,
  required double deviceWidth,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: ManagerHeight.h10,
      left: ManagerWidth.w14,
      right: ManagerWidth.w14,
    ),
    child: Container(
      width: double.infinity,
      height: ManagerHeight.h115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ManagerRadius.r6,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: deviceWidth * 0.30,
            child: Image.network(
              model.image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: ManagerWidth.w10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: ManagerColors.black,
                ),
              ),
              Text(
                model.subTitle,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    ManagerStrings.color,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.grey,
                    ),
                  ),
                  Text(
                    " ${model.color}",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.grey,
                    ),
                  ),
                  SizedBox(
                    width: ManagerWidth.w26,
                  ),
                  Text(
                    ManagerStrings.size,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.grey,
                    ),
                  ),
                  Text(
                    " ${model.size}",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ManagerStrings.units,
                        style: getMediumTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.grey,
                        ),
                      ),
                      Text(
                        " ${model.units}",
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      ManagerHeight.h10,
                    ),
                    child: Text(
                      "${model.price} ${model.currency}",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: ManagerColors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}
