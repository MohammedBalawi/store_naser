import 'package:app_mobile/features/logout/data/data_source/logout_data_source.dart';
import 'package:app_mobile/features/logout/data/repository/logout_repository.dart';
import 'package:app_mobile/features/logout/domain/usecase/logout_usecase.dart';
import 'package:app_mobile/features/logout/presentation/controller/logout_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';
import 'logout_usecase.dart';

initLogout() {
  Get.put(LogoutController());
}

disposeLogout() {
  Get.delete<LogoutController>();
}

initLogoutRequest() async {
  if (!GetIt.I.isRegistered<LogoutRemoteDataSource>()) {
    instance.registerLazySingleton<LogoutRemoteDataSource>(
          () => LogoutRemoteDataSourceImplement(),
    );

  }

  if (!GetIt.I.isRegistered<LogoutRepository>()) {
    instance.registerLazySingleton<LogoutRepository>(
          () => LogoutRepositoryImplement(instance(), instance()),
    );
  }

  if (!GetIt.I.isRegistered<LogoutUseCase>()) {
    instance.registerFactory<LogoutUseCase>(
          () => LogoutUseCase(instance<LogoutRepository>()),
    );
  }
}


disposeLogoutRequest() {
  if (GetIt.I.isRegistered<LogoutRemoteDataSource>()) {
    instance.unregister<LogoutRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<LogoutRepository>()) {
    instance.unregister<LogoutRepository>();
  }

  if (GetIt.I.isRegistered<LogoutUseCase>()) {
    instance.unregister<LogoutUseCase>();
  }
}
