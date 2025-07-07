import 'package:app_mobile/features/chats/data/data_source/chats_data_source.dart';
import 'package:app_mobile/features/chats/data/mapper/chats_mapper.dart';
import 'package:app_mobile/features/chats/domain/model/chats_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class ChatsRepository {
  Future<Either<Failure, ChatsModel>> chats();
}

class ChatsRepositoryImplement implements ChatsRepository {
  ChatsDataSource remoteDataSource;
  NetworkInfo networkInfo;

  ChatsRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, ChatsModel>> chats() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.chats();
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
