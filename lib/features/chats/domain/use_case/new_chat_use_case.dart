import 'package:app_mobile/features/chats/data/repository/new_chat_repository.dart';
import 'package:app_mobile/features/chats/data/request/new_chat_request.dart';
import 'package:app_mobile/features/chats/domain/model/new_chat_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class NewChatUseCase implements BaseUseCase<NewChatRequest, NewChatModel> {
  final NewChatRepository _repository;

  NewChatUseCase(this._repository);

  @override
  Future<Either<Failure, NewChatModel>> execute(NewChatRequest request) async {
    return await _repository.newChat(
      request,
    );
  }
}
