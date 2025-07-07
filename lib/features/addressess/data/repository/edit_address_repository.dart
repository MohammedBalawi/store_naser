import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/addressess/data/data_source/edit_address_data_source.dart';
import 'package:app_mobile/features/addressess/data/mapper/edit_address_mapper.dart';
import 'package:app_mobile/features/addressess/data/request/edit_address_request.dart';
import 'package:app_mobile/features/addressess/domain/model/edit_address_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class EditAddressRepository {
  Future<Either<Failure, EditAddressModel>> editAddress(
      EditAddressRequest request);
}

class EditAddressRepositoryImplement implements EditAddressRepository {
  EditAddressRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  EditAddressRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, EditAddressModel>> editAddress(
      EditAddressRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.editAddress(
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
