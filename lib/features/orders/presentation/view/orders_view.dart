import 'package:flutter/material.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/orders/domain/di/orders_di.dart';
import 'package:app_mobile/features/orders/presentation/controller/orders_controller.dart';
import 'package:app_mobile/features/orders/presentation/view/no_orders_view.dart';
import 'package:app_mobile/features/orders/presentation/view/widgets/order_item.dart';
import 'package:app_mobile/features/orders/presentation/view/widgets/order_status_item.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.myOrders,
          ),
          backgroundColor: ManagerColors.background,
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: ManagerColors.primaryColor,),
                )
              : controller.noOrders()
                  ? const NoOrdersView()
                  : Container(
                      height: double.infinity,
                      color: ManagerColors.appBarShadow,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: ManagerHeight.h20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0;
                                  i < controller.orderStatuses.length;
                                  i++)
                                orderStatusItem(
                                  model: controller.orderStatuses[i],
                                  selected: controller.statusSelected(
                                    index: i,
                                  ),
                                  onPressed: () {
                                    controller.setStatusIndex(
                                      index: i,
                                    );
                                  },
                                ),
                            ],
                          ),
                          SizedBox(
                            height: ManagerHeight.h20,
                          ),
                          IndexedStack(
                            index: controller.statusIndex,
                            children: [
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < controller.finishedOrders.length;
                                      i++)
                                    orderItem(
                                      model: controller.finishedOrders[i],
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < controller.pendingOrders.length;
                                      i++)
                                    orderItem(
                                      model: controller.pendingOrders[i],
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < controller.cancelledOrders.length;
                                      i++)
                                    orderItem(
                                      model: controller.cancelledOrders[i],
                                    ),
                                ],
                              )
                            ],
                          )
                          // for (int i = 0; i < controller.finishedOrders.length; i++)
                          //   orderItem(
                          //     model: controller.finishedOrders[i],
                          //   ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  @override
  void dispose() {
    disposeOrders();
    super.dispose();
  }
}
