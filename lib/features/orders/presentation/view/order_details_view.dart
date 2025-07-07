import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/orders/presentation/controller/order_details_controller.dart';
import 'package:app_mobile/features/orders/presentation/view/widgets/order_info_item.dart';
import 'package:app_mobile/features/orders/presentation/view/widgets/order_product_item.dart';
import 'package:app_mobile/features/orders/presentation/view/widgets/order_step_item.dart';
import 'package:get/get.dart';
import '../../../../core/funs/format_date.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/main_app_bar.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      builder: (controller) {
        Size size = MediaQuery.of(context).size;
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.orderDetails,
          ),
          backgroundColor: ManagerColors.background,
          body: ListView(
            shrinkWrap: true,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ManagerHeight.h38,
                        right: ManagerHeight.h38,
                        top: ManagerHeight.h40),
                    child: Container(
                      width: controller.setGradient(
                        width: size.width,
                      ),
                      //double.infinity,
                      height: ManagerHeight.h40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ManagerColors.greenAccent,
                            ManagerColors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      orderStepItem(
                        enabled: controller.getEnabledStep(
                          index: 0,
                        ),
                        icon: ManagerIcons.waterDrop,
                        title: ManagerStrings.orderPrepare,
                      ),
                      orderStepItem(
                        enabled: controller.getEnabledStep(
                          index: 1,
                        ),
                        icon: ManagerIcons.localShipping,
                        title: ManagerStrings.orderSent,
                      ),
                      orderStepItem(
                        enabled: controller.getEnabledStep(
                          index: 1,
                        ),
                        icon: ManagerIcons.gift,
                        title: ManagerStrings.oderCompleted,
                      ),

                      // for (int i = 0; i < 3; i++)
                    ],
                  ),
                ],
              ),
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
                      ' ${controller.order.data.number} ',
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
                        date: controller.order.data.dateTime,
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
                padding: EdgeInsets.only(
                  left: ManagerWidth.w12,
                  right: ManagerWidth.w12,
                ),
                child: Row(
                  children: [
                    Text(
                      ManagerStrings.orderNumber,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.grey,
                      ),
                    ),
                    Text(
                      ' ${controller.order.data.products.length} ',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < controller.order.data.products.length; i++)
                orderProductItem(
                  model: controller.order.data.products[i],
                  deviceWidth: size.width,
                ),
              Padding(
                padding: EdgeInsets.all(
                  ManagerHeight.h10,
                ),
                child: Text(
                  ManagerStrings.orderInfo,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                ),
              ),
              orderInfoItem(
                model: controller.order.data.info,
              ),
              //@todo: Adding the footer here
              Padding(
                padding: EdgeInsets.all(
                  ManagerHeight.h12,
                ),
                child: mainButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(ManagerStrings.startButton,)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
