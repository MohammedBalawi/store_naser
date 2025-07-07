import 'package:app_mobile/features/favorite/data/data_source/add_favorite_data_source.dart';
import 'package:app_mobile/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:app_mobile/features/favorite/data/repository/add_favorite_repository.dart';
import 'package:app_mobile/features/favorite/data/repository/favorite_repository.dart';
import 'package:app_mobile/features/favorite/domain/usecase/add_favorite_usecase.dart';
import 'package:app_mobile/features/favorite/domain/usecase/favorite_usecase.dart';
import 'package:app_mobile/features/favorite/presentation/controller/favorite_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initFavorite() {
  Get.put(FavoriteController());
}

disposeFavorite() {
  Get.delete<FavoriteController>();
}

initFavoriteRequest() async {
  if (!GetIt.I.isRegistered<FavoriteRemoteDataSource>()) {
    instance.registerLazySingleton<FavoriteRemoteDataSource>(
        () => FavoriteRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<FavoriteRepository>()) {
    instance.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<FavoriteUseCase>()) {
    instance.registerFactory<FavoriteUseCase>(
        () => FavoriteUseCase(instance<FavoriteRepository>()));
  }
}

disposeFavoriteRequest() {
  if (GetIt.I.isRegistered<FavoriteRemoteDataSource>()) {
    instance.unregister<FavoriteRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<FavoriteRepository>()) {
    instance.unregister<FavoriteRepository>();
  }

  if (GetIt.I.isRegistered<FavoriteUseCase>()) {
    instance.unregister<FavoriteUseCase>();
  }
}

initAddFavoriteRequest() async {
  if (!GetIt.I.isRegistered<AddFavoriteRemoteDataSource>()) {
    instance.registerLazySingleton<AddFavoriteRemoteDataSource>(
        () => AddFavoriteRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddFavoriteRepository>()) {
    instance.registerLazySingleton<AddFavoriteRepository>(
        () => AddFavoriteRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddFavoriteUseCase>()) {
    instance.registerFactory<AddFavoriteUseCase>(
        () => AddFavoriteUseCase(instance<AddFavoriteRepository>()));
  }
}

disposeAddFavoriteRequest() {
  if (GetIt.I.isRegistered<AddFavoriteRemoteDataSource>()) {
    instance.unregister<AddFavoriteRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<AddFavoriteRepository>()) {
    instance.unregister<AddFavoriteRepository>();
  }

  if (GetIt.I.isRegistered<AddFavoriteUseCase>()) {
    instance.unregister<AddFavoriteUseCase>();
  }
}
