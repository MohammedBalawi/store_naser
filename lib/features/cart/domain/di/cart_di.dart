import 'package:app_mobile/features/cart/data/data_source/cart_data_source.dart';
import 'package:app_mobile/features/cart/data/repository/cart_repository.dart';
import 'package:app_mobile/features/cart/domain/usecase/cart_usecase.dart';
import 'package:app_mobile/features/cart/presentation/controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initCart() {
  Get.put(CartController());
}

disposeCart() {
  Get.delete<CartController>();
}

initCartRequest() async {
  if (!GetIt.I.isRegistered<CartRemoteDataSource>()) {
    instance.registerLazySingleton<CartRemoteDataSource>(
        () => CartRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CartRepository>()) {
    instance.registerLazySingleton<CartRepository>(
        () => CartRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CartUseCase>()) {
    instance.registerFactory<CartUseCase>(
        () => CartUseCase(instance<CartRepository>()));
  }
}

disposeCartRequest() {
  if (GetIt.I.isRegistered<CartRemoteDataSource>()) {
    instance.unregister<CartRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<CartRepository>()) {
    instance.unregister<CartRepository>();
  }

  if (GetIt.I.isRegistered<CartUseCase>()) {
    instance.unregister<CartUseCase>();
  }
}
