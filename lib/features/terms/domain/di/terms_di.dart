import 'package:app_mobile/features/terms/data/data_source/accept_terms_data_source.dart';
import 'package:app_mobile/features/terms/data/data_source/terms_data_source.dart';
import 'package:app_mobile/features/terms/data/repository/accept_terms_repository.dart';
import 'package:app_mobile/features/terms/data/repository/terms_repository.dart';
import 'package:app_mobile/features/terms/domain/usecase/accept_terms_usecase.dart';
import 'package:app_mobile/features/terms/domain/usecase/terms_usecase.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';
import '../../presentation/controller/terms_controller.dart';

initTerms() {
  Get.put(TermsController());
}

disposeTerms() {
  Get.delete<TermsController>();
}

initTermsRequest() async {
  if (!GetIt.I.isRegistered<TermsRemoteDataSource>()) {
    instance.registerLazySingleton<TermsRemoteDataSource>(
        () => TermsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<TermsRepository>()) {
    instance.registerLazySingleton<TermsRepository>(
        () => TermsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<TermsUseCase>()) {
    instance.registerFactory<TermsUseCase>(
        () => TermsUseCase(instance<TermsRepository>()));
  }
}

disposeTermsRequest() {
  if (GetIt.I.isRegistered<TermsRemoteDataSource>()) {
    instance.unregister<TermsRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<TermsRepository>()) {
    instance.unregister<TermsRepository>();
  }

  if (GetIt.I.isRegistered<TermsUseCase>()) {
    instance.unregister<TermsUseCase>();
  }
}


initAcceptTermsRequest() async {
  if (!GetIt.I.isRegistered<AcceptTermsRemoteDataSource>()) {
    instance.registerLazySingleton<AcceptTermsRemoteDataSource>(
            () => AcceptTermsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AcceptTermsRepository>()) {
    instance.registerLazySingleton<AcceptTermsRepository>(
            () => AcceptTermsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AcceptTermsUseCase>()) {
    instance.registerFactory<AcceptTermsUseCase>(
            () => AcceptTermsUseCase(instance<AcceptTermsRepository>()));
  }
}

disposeAcceptTermsRequest() {
  if (GetIt.I.isRegistered<AcceptTermsRemoteDataSource>()) {
    instance.unregister<AcceptTermsRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<AcceptTermsRepository>()) {
    instance.unregister<AcceptTermsRepository>();
  }

  if (GetIt.I.isRegistered<AcceptTermsUseCase>()) {
    instance.unregister<AcceptTermsUseCase>();
  }
}

