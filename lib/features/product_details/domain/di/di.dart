import 'package:app_mobile/features/product_details/data/data_source/add_rate_data_source.dart';
import 'package:app_mobile/features/product_details/data/data_source/product_details_data_source.dart';
import 'package:app_mobile/features/product_details/data/repository/add_rate_repository.dart';
import 'package:app_mobile/features/product_details/data/repository/product_details_repository.dart';
import 'package:app_mobile/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:app_mobile/features/product_details/presentation/controller/add_rate_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';
import '../../presentation/controller/product_details_controller.dart';
import '../use_case/add_rate_use_case.dart';

void initProductDetails() {
  Get.put(ProductDetailsController());
}

void disposeProductDetails() {
  Get.delete<ProductDetailsController>();
}

void initAddRate() {
  Get.put(AddRateController());
}

void disposeAddRate() {
  Get.delete<AddRateController>();
}

initProductDetailsRequest() async {
  if (!GetIt.I.isRegistered<ProductDetailsDataSource>()) {
    instance.registerLazySingleton<ProductDetailsDataSource>(
        () => ProductDetailsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<ProductDetailsRepository>()) {
    instance.registerLazySingleton<ProductDetailsRepository>(
        () => ProductDetailsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<ProductDetailsUseCase>()) {
    instance.registerFactory<ProductDetailsUseCase>(
        () => ProductDetailsUseCase(instance<ProductDetailsRepository>()));
  }
}

disposeProductDetailsRequest() {
  if (GetIt.I.isRegistered<ProductDetailsDataSource>()) {
    instance.unregister<ProductDetailsDataSource>();
  }

  if (GetIt.I.isRegistered<ProductDetailsRepository>()) {
    instance.unregister<ProductDetailsRepository>();
  }

  if (GetIt.I.isRegistered<ProductDetailsUseCase>()) {
    instance.unregister<ProductDetailsUseCase>();
  }
}

initAddRateRequest() async {
  if (!GetIt.I.isRegistered<AddRateDataSource>()) {
    instance.registerLazySingleton<AddRateDataSource>(
        () => AddRateRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddRateRepository>()) {
    instance.registerLazySingleton<AddRateRepository>(
        () => AddRateRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddRateUseCase>()) {
    instance.registerFactory<AddRateUseCase>(
        () => AddRateUseCase(instance<AddRateRepository>()));
  }
}

disposeAddRateRequest() {
  if (GetIt.I.isRegistered<AddRateDataSource>()) {
    instance.unregister<AddRateDataSource>();
  }

  if (GetIt.I.isRegistered<AddRateRepository>()) {
    instance.unregister<AddRateRepository>();
  }

  if (GetIt.I.isRegistered<AddRateUseCase>()) {
    instance.unregister<AddRateUseCase>();
  }
}
