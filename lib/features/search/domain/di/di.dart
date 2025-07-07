import 'package:app_mobile/features/search/data/data_source/search_data_source.dart';
import 'package:app_mobile/features/search/data/repository/search_repository.dart';
import 'package:app_mobile/features/search/domain/use_case/search_use_case.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initSearchRequest() async {
  if (!GetIt.I.isRegistered<SearchDataSource>()) {
    instance.registerLazySingleton<SearchDataSource>(
            () => SearchRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<SearchRepository>()) {
    instance.registerLazySingleton<SearchRepository>(
            () => SearchRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<SearchUseCase>()) {
    instance.registerFactory<SearchUseCase>(
            () => SearchUseCase(instance<SearchRepository>()));
  }
}

disposeSearchRequest() {
  if (GetIt.I.isRegistered<SearchDataSource>()) {
    instance.unregister<SearchDataSource>();
  }

  if (GetIt.I.isRegistered<SearchRepository>()) {
    instance.unregister<SearchRepository>();
  }

  if (GetIt.I.isRegistered<SearchUseCase>()) {
    instance.unregister<SearchUseCase>();
  }
}

