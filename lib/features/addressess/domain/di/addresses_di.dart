import 'package:app_mobile/features/addressess/data/data_source/add_address_data_source.dart';
import 'package:app_mobile/features/addressess/data/data_source/addresses_data_source.dart';
import 'package:app_mobile/features/addressess/data/data_source/delete_address_data_source.dart';
import 'package:app_mobile/features/addressess/data/data_source/edit_address_data_source.dart';
import 'package:app_mobile/features/addressess/data/repository/add_address_repository.dart';
import 'package:app_mobile/features/addressess/data/repository/addresses_repository.dart';
import 'package:app_mobile/features/addressess/data/repository/delete_address_repository.dart';
import 'package:app_mobile/features/addressess/data/repository/edit_address_repository.dart';
import 'package:app_mobile/features/addressess/domain/usecase/add_address_usecase.dart';
import 'package:app_mobile/features/addressess/domain/usecase/addresses_usecase.dart';
import 'package:app_mobile/features/addressess/domain/usecase/delete_address_usecase.dart';
import 'package:app_mobile/features/addressess/domain/usecase/edit_address_usecase.dart';
import 'package:app_mobile/features/addressess/presentation/controller/add_address_controller.dart';
import 'package:app_mobile/features/addressess/presentation/controller/addresses_controller.dart';
import 'package:app_mobile/features/addressess/presentation/controller/edit_address_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';

initAddresses() {
  Get.put(AddressesController());
}

disposeAddresses() {
  Get.delete<AddressesController>();
}

initAddAddress() {
  Get.put(AddAddressController());
}

disposeAddAddress() {
  Get.delete<AddAddressController>();
}

initEditAddress() {
  Get.put(EditAddressController());
}

disposeEditAddress() {
  Get.delete<EditAddressController>();
}

initAddressesRequest() async {
  if (!GetIt.I.isRegistered<AddressesRemoteDataSource>()) {
    instance.registerLazySingleton<AddressesRemoteDataSource>(
        () => AddressesRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddressesRepository>()) {
    instance.registerLazySingleton<AddressesRepository>(
        () => AddressesRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddressesUseCase>()) {
    instance.registerFactory<AddressesUseCase>(
        () => AddressesUseCase(instance<AddressesRepository>()));
  }
}

disposeAddressesRequest() {
  if (GetIt.I.isRegistered<AddressesRemoteDataSource>()) {
    instance.unregister<AddressesRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<AddressesRepository>()) {
    instance.unregister<AddressesRepository>();
  }

  if (GetIt.I.isRegistered<AddressesUseCase>()) {
    instance.unregister<AddressesUseCase>();
  }
}

initAddAddressRequest() async {
  if (!GetIt.I.isRegistered<AddAddressRemoteDataSource>()) {
    instance.registerLazySingleton<AddAddressRemoteDataSource>(
        () => AddAddressRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddAddressRepository>()) {
    instance.registerLazySingleton<AddAddressRepository>(
        () => AddAddressRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddAddressUseCase>()) {
    instance.registerFactory<AddAddressUseCase>(
        () => AddAddressUseCase(instance<AddAddressRepository>()));
  }
}

disposeAddAddressRequest() {
  if (GetIt.I.isRegistered<AddAddressRemoteDataSource>()) {
    instance.unregister<AddAddressRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<AddAddressRepository>()) {
    instance.unregister<AddAddressRepository>();
  }

  if (GetIt.I.isRegistered<AddAddressUseCase>()) {
    instance.unregister<AddAddressUseCase>();
  }
}

initDeleteAddressRequest() async {
  if (!GetIt.I.isRegistered<DeleteAddressRemoteDataSource>()) {
    instance.registerLazySingleton<DeleteAddressRemoteDataSource>(
        () => DeleteAddressRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<DeleteAddressRepository>()) {
    instance.registerLazySingleton<DeleteAddressRepository>(
        () => DeleteAddressRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<DeleteAddressUseCase>()) {
    instance.registerFactory<DeleteAddressUseCase>(
        () => DeleteAddressUseCase(instance<DeleteAddressRepository>()));
  }
}

disposeDeleteAddressRequest() {
  if (GetIt.I.isRegistered<DeleteAddressRemoteDataSource>()) {
    instance.unregister<DeleteAddressRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<DeleteAddressRepository>()) {
    instance.unregister<DeleteAddressRepository>();
  }

  if (GetIt.I.isRegistered<DeleteAddressUseCase>()) {
    instance.unregister<DeleteAddressUseCase>();
  }
}

initEditAddressRequest() async {
  if (!GetIt.I.isRegistered<EditAddressRemoteDataSource>()) {
    instance.registerLazySingleton<EditAddressRemoteDataSource>(
        () => EditAddressRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<EditAddressRepository>()) {
    instance.registerLazySingleton<EditAddressRepository>(
        () => EditAddressRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<EditAddressUseCase>()) {
    instance.registerFactory<EditAddressUseCase>(
        () => EditAddressUseCase(instance<EditAddressRepository>()));
  }
}

disposeEditAddressRequest() {
  if (GetIt.I.isRegistered<EditAddressRemoteDataSource>()) {
    instance.unregister<EditAddressRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<EditAddressRepository>()) {
    instance.unregister<EditAddressRepository>();
  }

  if (GetIt.I.isRegistered<EditAddressUseCase>()) {
    instance.unregister<EditAddressUseCase>();
  }
}
