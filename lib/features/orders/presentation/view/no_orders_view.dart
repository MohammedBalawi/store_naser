import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/orders/presentation/controller/orders_controller.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';

class NoOrdersView extends StatelessWidget {
  const NoOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(
            ManagerHeight.h20,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset(
                ManagerImages.noOrders,
              ),
              SizedBox(
                height: ManagerHeight.h10,
              ),
              Center(
                child: Text(
                  ManagerStrings.noOrdersFound,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.black,
                  ),
                ),
              ),
              SizedBox(
                height: ManagerHeight.h30,
              ),
              Text(
                ManagerStrings.youDontHaveOrders,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ManagerHeight.h30,
              ),
              mainButton(
                buttonName: ManagerStrings.startShopping,
                onPressed: () {
                  controller.navigateToHome();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
