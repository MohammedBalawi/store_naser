import 'package:app_mobile/features/auth/data/data_source/login_data_source.dart';
import 'package:app_mobile/features/auth/data/mapper/login_mapper.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../domain/models/login_model.dart';
import 'package:dartz/dartz.dart';
import '../request/login_request.dart';

abstract class LoginRepository {
  Future<Either<Failure, Login>> login(
    LoginRequest loginRequest,
  );
}

class LoginRepoImplement implements LoginRepository {
  LoginRemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  LoginRepoImplement(this._networkInfo, this._remoteDataSource);

  @override
  Future<Either<Failure, Login>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await _remoteDataSource.login(loginRequest);
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
