import 'package:app_mobile/features/change_password/data/data_source/change_password_data_source.dart';
import 'package:app_mobile/features/change_password/data/mapper/change_password_mapper.dart';
import 'package:app_mobile/features/change_password/data/request/change_password_request.dart';
import 'package:app_mobile/features/change_password/domain/model/change_password_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';
import 'package:dartz/dartz.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, ChangePasswordModel>> changePassword(
    ChangePasswordRequest request,
  );
}

class ChangePasswordRepositoryImplement implements ChangePasswordRepository {
  ChangePasswordDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  ChangePasswordRepositoryImplement(this._networkInfo, this._remoteDataSource);

  @override
  Future<Either<Failure, ChangePasswordModel>> changePassword(
      ChangePasswordRequest request) async {
    if (await _networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await _remoteDataSource.changePassword(
          request,
        );
        return Right(response.toDomain());
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(Failure(ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION));
    }
  }
}
