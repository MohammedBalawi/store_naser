import 'package:flutter/material.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_info_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';

Widget orderInfoItem({required FinishedOrderInfoModel model,}){
  return Padding(
    padding:  EdgeInsets.all(ManagerWidth.w12,),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: ManagerColors.grey,),
        borderRadius: BorderRadius.circular(ManagerRadius.r10,),
      ),
      child: Padding(
        padding:  EdgeInsets.all(ManagerWidth.w10,),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  ManagerStrings.shippingMethod,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ManagerStrings.paymentWay,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ManagerStrings.submitWay,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ManagerStrings.discount,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ManagerStrings.totalPrice,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  ' ${model.shippingMethod} ',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ' ${model.payment.number} ',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ' ${model.submitWay} ',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Text(
                  ' ${model.discount} ',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ' ${model.price} ',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.black,
                      ),
                    ),
                    Text(
                      ' ${model.currency}',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.red,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}