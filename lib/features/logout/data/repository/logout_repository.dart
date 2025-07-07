import 'package:app_mobile/features/logout/data/repository/logout_mapper.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/logout/data/data_source/logout_data_source.dart';
import 'package:app_mobile/features/logout/data/mapper/logout_mapper.dart';
import 'package:app_mobile/features/logout/domain/model/logout_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class LogoutRepository {
  Future<Either<Failure, LogoutModel>> logout();
}

class LogoutRepositoryImplement implements LogoutRepository {
  LogoutRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  LogoutRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.logout();
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
