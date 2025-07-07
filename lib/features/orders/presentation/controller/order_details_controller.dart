import 'package:app_mobile/features/orders/data/request/finished_order_request.dart';
import 'package:app_mobile/features/orders/domain/di/orders_di.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_data_model.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_info_model.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_model.dart';
import 'package:app_mobile/features/orders/domain/model/order_payment_model.dart';
import 'package:app_mobile/features/orders/domain/usecase/finished_order_usecase.dart';
import 'package:get/get.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';

class OrderDetailsController extends GetxController {
  FinishedOrderModel order = FinishedOrderModel(
    data: FinishedOrderDataModel(
      number: "",
      step: "",
      dateTime: "",
      info: FinishedOrderInfoModel(
        shippingMethod: "",
        payment: OrderPaymentModel(
          number: "",
          title: "",
        ),
        submitWay: "",
        discount: "",
        currency: "",
        price: 0.00,
      ),
      products: [],
    ),
  );
  bool isLoading = true;
  int step = 2;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void setStep({required int value,}){
    step = value;
    update();
  }
  bool getEnabledStep({required int index,}){
    if(index <= step){
      return true;
    }
    return false;
  }

  double setGradient({required double width}){
    if(step == 0){
      return width/3.8;
    }
    if(step == 1){
      return width/2;
    }else{
      return width/1;
    }
  }

  void fetchOrder() async {
    CacheData cacheData = CacheData();
    try {
      changeIsLoading(
        value: true,
      );
      final FinishedOrderUseCase useCase = instance<FinishedOrderUseCase>();
      (await useCase.execute(FinishedOrderRequest(
        id: cacheData.getOrderId(),
      )))
          .fold(
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
          order = r;
          update();
        },
      );
    } catch (e) {
      //@todo: Call the failed toast
    }
  }

  @override
  void onInit() {
    initFinishedOrderRequest();
    fetchOrder();
    super.onInit();
  }

  @override
  void dispose() {
    disposeFinishedOrderRequest();
    super.dispose();
  }
}
