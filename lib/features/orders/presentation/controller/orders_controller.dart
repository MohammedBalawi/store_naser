import 'package:app_mobile/features/orders/domain/di/orders_di.dart';
import 'package:app_mobile/features/orders/domain/usecase/orders_usecase.dart';
import 'package:app_mobile/features/orders/presentation/model/order_status_model.dart';
import 'package:get/get.dart';
import '../../../../constants/constants/constants.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes/routes.dart';
import '../../domain/model/order_model.dart';

class OrdersController extends GetxController {
  List<OrderStatusModel> orderStatuses = [];

  List<OrderModel> finishedOrders = [];
  List<OrderModel> pendingOrders = [];
  List<OrderModel> cancelledOrders = [];
  bool isLoading = true;
  int statusIndex = 0;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void setStatusIndex({
    required int index,
  }) {
    statusIndex = index;
    update();
  }

  bool statusSelected({
    required int index,
  }) {
    return index == statusIndex;
  }

  void setOrderStatuses() {
    orderStatuses = [
      OrderStatusModel(
        title: ManagerStrings.orderStatusFinished,
        status: Constants.orderStatusFinished,
        color: ManagerColors.statusFinished,
      ),
      OrderStatusModel(
        title: ManagerStrings.orderStatusPending,
        status: Constants.orderStatusPending,
        color: ManagerColors.statusPending,
      ),
      OrderStatusModel(
        title: ManagerStrings.orderStatusCancelled,
        status: Constants.orderStatusCancelled,
        color: ManagerColors.statusCancelled,
      ),
    ];
  }

  void navigateToOrderDetails({
    required OrderModel model,
  }) {
    if (!(model.statusModel.status == Constants.orderStatusCancelled)) {
      CacheData cacheData = CacheData();
      cacheData.setOrderId(
        model.id,
      );
      Get.toNamed(
        Routes.orderDetails,
      );
    }
  }

  void ordersRequest() async {
    try {
      changeIsLoading(
        value: true,
      );
      final OrdersUseCase useCase = instance<OrdersUseCase>();
      (await useCase.execute()).fold(
        (l) {
          changeIsLoading(
            value: false,
          );
          //@todo: Call the failed toast
        },
        (r) async {
          changeIsLoading(
            value: false,
          );
          for (int i = 0; i < r.data.length; i++) {
            switch (r.data[i].statusModel.status) {
              case Constants.orderStatusFinished:
                finishedOrders.add(r.data[i]);
              case Constants.orderStatusPending:
                pendingOrders.add(r.data[i]);
              case Constants.orderStatusCancelled:
                cancelledOrders.add(r.data[i]);
              default:
                finishedOrders.add(r.data[i]);
            }
          }
          update();
        },
      );
    } catch (e) {
      //@todo: Call the failed toast
    }
  }

  void getBillDetails({
    required OrderModel model,
  }) {
    //@todo: implement bill details
  }

  bool noOrders() {
    return (finishedOrders.isEmpty) &&
        (cancelledOrders.isEmpty) &&
        (pendingOrders.isEmpty);
  }

  void navigateToHome() {
    Get.back();
  }

  @override
  void onInit() {
    setOrderStatuses();
    initOrdersRequest();
    ordersRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeOrdersRequest();
    super.dispose();
  }
}
