import 'package:app_mobile/features/change_password/data/data_source/change_password_data_source.dart';
import 'package:app_mobile/features/change_password/data/repository/change_password_repository.dart';
import 'package:app_mobile/features/change_password/domain/use_case/change_password_use_case.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initChangePasswordRequest() async {
  finishLoginModule();
  if (!GetIt.I.isRegistered<ChangePasswordDataSource>()) {
    instance.registerLazySingleton<ChangePasswordDataSource>(
        () => ChangePasswordRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<ChangePasswordRepository>()) {
    instance.registerLazySingleton<ChangePasswordRepository>(
        () => ChangePasswordRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<ChangePasswordUseCase>()) {
    instance.registerFactory<ChangePasswordUseCase>(
        () => ChangePasswordUseCase(instance<ChangePasswordRepository>()));
  }
}

disposeChangePasswordRequest() async {
  if (GetIt.I.isRegistered<ChangePasswordDataSource>()) {
    instance.unregister<ChangePasswordDataSource>();
  }

  if (GetIt.I.isRegistered<ChangePasswordRepository>()) {
    instance.unregister<ChangePasswordRepository>();
  }

  if (GetIt.I.isRegistered<ChangePasswordUseCase>()) {
    instance.unregister<ChangePasswordUseCase>();
  }
}
