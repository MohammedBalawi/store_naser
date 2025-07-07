import 'package:app_mobile/features/chats/data/repository/send_message_repository.dart';
import 'package:app_mobile/features/chats/data/request/send_message_request.dart';
import 'package:app_mobile/features/chats/domain/model/send_message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class SendMessageUseCase
    implements BaseUseCase<SendMessageRequest, SendMessageModel> {
  final SendMessageRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, SendMessageModel>> execute(
      SendMessageRequest request) async {
    return await _repository.sendMessage(
      request,
    );
  }
}
