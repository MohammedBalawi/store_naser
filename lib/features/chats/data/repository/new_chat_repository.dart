import 'package:app_mobile/features/chats/data/data_source/new_chat_data_source.dart';
import 'package:app_mobile/features/chats/data/mapper/new_chat_mapper.dart';
import 'package:app_mobile/features/chats/data/request/new_chat_request.dart';
import 'package:app_mobile/features/chats/domain/model/new_chat_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class NewChatRepository {
  Future<Either<Failure, NewChatModel>> newChat(NewChatRequest request);
}

class NewChatRepositoryImplement implements NewChatRepository {
  NewChatDataSource remoteDataSource;
  NetworkInfo networkInfo;

  NewChatRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, NewChatModel>> newChat(NewChatRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.newChat(request);
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
