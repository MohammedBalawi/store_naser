import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/addressess/data/data_source/delete_address_data_source.dart';
import 'package:app_mobile/features/addressess/data/mapper/delete_address_mapper.dart';
import 'package:app_mobile/features/addressess/data/request/delete_address_request.dart';
import 'package:app_mobile/features/addressess/domain/model/delete_address_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class DeleteAddressRepository {
  Future<Either<Failure, DeleteAddressModel>> deleteAddress(
      DeleteAddressRequest request);
}

class DeleteAddressRepositoryImplement implements DeleteAddressRepository {
  DeleteAddressRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  DeleteAddressRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, DeleteAddressModel>> deleteAddress(
      DeleteAddressRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.deleteAddress(
          request,
        );
        return Right(response.toDomain());
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(
        Failure(
          ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION,
        ),
      );
    }
  }
}
