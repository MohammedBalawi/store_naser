import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:app_mobile/features/notifications/data/mapper/notifications_mapper.dart';
import 'package:app_mobile/features/notifications/domain/models/notifications_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsModel>> notifications();
}

class NotificationsRepositoryImplement implements NotificationsRepository {
  NotificationsRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  NotificationsRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, NotificationsModel>> notifications() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.notifications();
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
