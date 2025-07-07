import 'package:app_mobile/features/chats/data/data_source/send_message_data_source.dart';
import 'package:app_mobile/features/chats/data/mapper/send_message_mapper.dart';
import 'package:app_mobile/features/chats/data/request/send_message_request.dart';
import 'package:app_mobile/features/chats/domain/model/send_message_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class SendMessageRepository {
  Future<Either<Failure, SendMessageModel>> sendMessage(
      SendMessageRequest request);
}

class SendMessageRepositoryImplement implements SendMessageRepository {
  SendMessageDataSource remoteDataSource;
  NetworkInfo networkInfo;

  SendMessageRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, SendMessageModel>> sendMessage(
      SendMessageRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.sendMessage(request);
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
