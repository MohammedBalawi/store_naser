import 'package:app_mobile/features/categories/data/data_source/categories_data_source.dart';
import 'package:app_mobile/features/categories/data/data_source/category_products_data_source.dart';
import 'package:app_mobile/features/categories/data/repository/categories_repository.dart';
import 'package:app_mobile/features/categories/data/repository/category_products_repository.dart';
import 'package:app_mobile/features/categories/domain/usecase/categories_usecase.dart';
import 'package:app_mobile/features/categories/domain/usecase/category_products_usecase.dart';
import 'package:app_mobile/features/categories/presentation/controller/categories_controller.dart';
import 'package:app_mobile/features/categories/presentation/controller/category_products_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initCategories() {
  Get.put(CategoriesController());
}

disposeCategories() {
  Get.delete<CategoriesController>();
}

initCategoryProducts() {
  Get.put(CategoryProductsController());
}

disposeCategoryProducts() {
  Get.delete<CategoryProductsController>();
}

initCategoriesRequest() async {
  if (!GetIt.I.isRegistered<CategoriesRemoteDataSource>()) {
    instance.registerLazySingleton<CategoriesRemoteDataSource>(
        () => CategoriesRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CategoriesRepository>()) {
    instance.registerLazySingleton<CategoriesRepository>(
        () => CategoriesRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CategoriesUseCase>()) {
    instance.registerFactory<CategoriesUseCase>(
        () => CategoriesUseCase(instance<CategoriesRepository>()));
  }
}

disposeCategoriesRequest() {
  if (GetIt.I.isRegistered<CategoriesRemoteDataSource>()) {
    instance.unregister<CategoriesRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<CategoriesRepository>()) {
    instance.unregister<CategoriesRepository>();
  }

  if (GetIt.I.isRegistered<CategoriesUseCase>()) {
    instance.unregister<CategoriesUseCase>();
  }
}

initCategoryProductsRequest() async {
  if (!GetIt.I.isRegistered<CategoryProductsRemoteDataSource>()) {
    instance.registerLazySingleton<CategoryProductsRemoteDataSource>(() =>
        CategoryProductsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CategoryProductsRepository>()) {
    instance.registerLazySingleton<CategoryProductsRepository>(
        () => CategoryProductsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CategoryProductsUseCase>()) {
    instance.registerFactory<CategoryProductsUseCase>(
        () => CategoryProductsUseCase(instance<CategoryProductsRepository>()));
  }
}

disposeCategoryProductsRequest() {
  if (GetIt.I.isRegistered<CategoryProductsRemoteDataSource>()) {
    instance.unregister<CategoryProductsRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<CategoryProductsRepository>()) {
    instance.unregister<CategoryProductsRepository>();
  }

  if (GetIt.I.isRegistered<CategoryProductsUseCase>()) {
    instance.unregister<CategoryProductsUseCase>();
  }
}
