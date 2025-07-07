import 'package:app_mobile/features/products/data/data_source/products_data_source.dart';
import 'package:app_mobile/features/products/data/repository/products_repository.dart';
import 'package:app_mobile/features/products/domain/use_case/products_use_case.dart';
import 'package:app_mobile/features/products/presentation/controller/products_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

void initProducts() {
  Get.put(ProductsController());
}

void disposeProducts() {
  Get.delete<ProductsController>();
}

initProductsRequest() async {
  if (!GetIt.I.isRegistered<ProductsDataSource>()) {
    instance.registerLazySingleton<ProductsDataSource>(
        () => ProductsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<ProductsRepository>()) {
    instance.registerLazySingleton<ProductsRepository>(
        () => ProductsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<ProductsUseCase>()) {
    instance.registerFactory<ProductsUseCase>(
        () => ProductsUseCase(instance<ProductsRepository>()));
  }
}

disposeProductsRequest() {
  if (GetIt.I.isRegistered<ProductsDataSource>()) {
    instance.unregister<ProductsDataSource>();
  }

  if (GetIt.I.isRegistered<ProductsRepository>()) {
    instance.unregister<ProductsRepository>();
  }

  if (GetIt.I.isRegistered<ProductsUseCase>()) {
    instance.unregister<ProductsUseCase>();
  }
}
