import 'package:app_mobile/features/delete_account/data/data_source/delete_account_data_source.dart';
import 'package:app_mobile/features/delete_account/data/repository/delete_account_repository.dart';
import 'package:app_mobile/features/delete_account/domain/usecase/delete_account_usecase.dart';
import 'package:app_mobile/features/delete_account/presentation/controller/delete_account_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initDeleteAccount() {
  Get.put(DeleteAccountController());
}

disposeDeleteAccount() {
  Get.delete<DeleteAccountController>();
}

initDeleteAccountRequest() async {
  if (!GetIt.I.isRegistered<DeleteAccountRemoteDataSource>()) {
    instance.registerLazySingleton<DeleteAccountRemoteDataSource>(
        () => DeleteAccountRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<DeleteAccountRepository>()) {
    instance.registerLazySingleton<DeleteAccountRepository>(
        () => DeleteAccountRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<DeleteAccountUseCase>()) {
    instance.registerFactory<DeleteAccountUseCase>(
        () => DeleteAccountUseCase(instance<DeleteAccountRepository>()));
  }
}

disposeDeleteAccountRequest() {
  if (GetIt.I.isRegistered<DeleteAccountRemoteDataSource>()) {
    instance.unregister<DeleteAccountRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<DeleteAccountRepository>()) {
    instance.unregister<DeleteAccountRepository>();
  }

  if (GetIt.I.isRegistered<DeleteAccountUseCase>()) {
    instance.unregister<DeleteAccountUseCase>();
  }
}
