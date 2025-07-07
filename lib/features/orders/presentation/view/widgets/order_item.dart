import 'package:flutter/material.dart';
import 'package:app_mobile/core/funs/format_date.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/orders/domain/model/order_model.dart';
import 'package:app_mobile/features/orders/presentation/controller/orders_controller.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_width.dart';

Widget orderItem({
  required OrderModel model,
}) {
  return GetBuilder<OrdersController>(builder: (controller) {
    return Padding(
      padding: EdgeInsets.all(
        ManagerHeight.h16,
      ),
      child: GestureDetector(
        onTap: () {
          controller.navigateToOrderDetails(
            model: model,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: ManagerColors.white,
            borderRadius: BorderRadius.circular(
              ManagerRadius.r12,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(
                  ManagerWidth.w12,
                ),
                child: Row(
                  children: [
                    Text(
                      ManagerStrings.orderNumber,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.black,
                      ),
                    ),
                    Text(
                      ' ${model.number} ',
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.black,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      formatDate(
                        date: model.dateTime,
                      ),
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  ManagerWidth.w12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ManagerStrings.receiverTitle,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.grey,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h20,
                        ),
                        Text(
                          ManagerStrings.quantity,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.grey,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h20,
                        ),
                        Text(
                          ManagerStrings.price,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ' ${model.title} ',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(
                          height: ManagerHeight.h20,
                        ),
                        Text(
                          ' ${model.quantity} ',
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
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  ManagerWidth.w12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.getBillDetails(
                          model: model,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ManagerRadius.r12,
                          ),
                          border: Border.all(
                            color: ManagerColors.black,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ManagerHeight.h10,
                            right: ManagerHeight.h10,
                            top: ManagerHeight.h6,
                            bottom: ManagerHeight.h6,
                          ),
                          child: Text(
                            ManagerStrings.billDetails,
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      model.statusModel.title,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: model.statusModel.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
