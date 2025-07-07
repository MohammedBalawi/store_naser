import 'package:app_mobile/features/chats/data/repository/chats_repository.dart';
import 'package:app_mobile/features/chats/domain/model/chats_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class ChatsUseCase implements BaseGetUseCase<ChatsModel> {
  final ChatsRepository _repository;

  ChatsUseCase(this._repository);

  @override
  Future<Either<Failure, ChatsModel>> execute() async {
    return await _repository.chats();
  }
}
