import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/delete_account/data/repository/delete_account_repository.dart';
import 'package:app_mobile/features/delete_account/domain/model/delete_account_model.dart';
import '../../../../core/error_handler/failure.dart';

class DeleteAccountUseCase implements BaseGetUseCase<DeleteAccountModel> {
  final DeleteAccountRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, DeleteAccountModel>> execute() async {
    return await _repository.deleteAccount();
  }
}
