import 'package:app_mobile/features/orders/data/data_source/finished_order_data_source.dart';
import 'package:app_mobile/features/orders/data/data_source/orders_data_source.dart';
import 'package:app_mobile/features/orders/data/repository/finished_order_repository.dart';
import 'package:app_mobile/features/orders/data/repository/orders_repository.dart';
import 'package:app_mobile/features/orders/domain/usecase/orders_usecase.dart';
import 'package:app_mobile/features/orders/presentation/controller/order_details_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';
import '../../../addressess/presentation/controller/addresses_controller.dart';
import '../../presentation/controller/orders_controller.dart';
import '../usecase/finished_order_usecase.dart';

initOrders() {
  Get.put(OrdersController());
}

disposeOrders() {
  Get.delete<OrdersController>();
}

initOrderDetails(){
  Get.put(OrderDetailsController());
}
disposeOrderDetails(){
  Get.delete<OrderDetailsController>();
}
initAddresses(){
  Get.put(AddressesController());
}
disposeAddresses(){
  Get.delete<AddressesController>();
}

initOrdersRequest() async {
  if (!GetIt.I.isRegistered<OrdersRemoteDataSource>()) {
    instance.registerLazySingleton<OrdersRemoteDataSource>(
        () => OrdersRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<OrdersRepository>()) {
    instance.registerLazySingleton<OrdersRepository>(
        () => OrdersRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<OrdersUseCase>()) {
    instance.registerFactory<OrdersUseCase>(
        () => OrdersUseCase(instance<OrdersRepository>()));
  }
}

disposeOrdersRequest() {
  if (GetIt.I.isRegistered<OrdersRemoteDataSource>()) {
    instance.unregister<OrdersRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<OrdersRepository>()) {
    instance.unregister<OrdersRepository>();
  }

  if (GetIt.I.isRegistered<OrdersUseCase>()) {
    instance.unregister<OrdersUseCase>();
  }
}

initFinishedOrderRequest() async {
  if (!GetIt.I.isRegistered<FinishedOrderRemoteDataSource>()) {
    instance.registerLazySingleton<FinishedOrderRemoteDataSource>(
        () => FinishedOrderRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<FinishedOrderRepository>()) {
    instance.registerLazySingleton<FinishedOrderRepository>(
        () => FinishedOrderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<FinishedOrderUseCase>()) {
    instance.registerFactory<FinishedOrderUseCase>(
        () => FinishedOrderUseCase(instance<FinishedOrderRepository>()));
  }
}

disposeFinishedOrderRequest() {
  if (GetIt.I.isRegistered<FinishedOrderRemoteDataSource>()) {
    instance.unregister<FinishedOrderRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<FinishedOrderRepository>()) {
    instance.unregister<FinishedOrderRepository>();
  }

  if (GetIt.I.isRegistered<FinishedOrderUseCase>()) {
    instance.unregister<FinishedOrderUseCase>();
  }
}
