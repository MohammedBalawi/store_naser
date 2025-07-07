import 'package:app_mobile/features/change_password/data/repository/change_password_repository.dart';
import 'package:app_mobile/features/change_password/data/request/change_password_request.dart';
import 'package:app_mobile/features/change_password/domain/model/change_password_model.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordUseCase
    implements BaseUseCase<ChangePasswordRequest, ChangePasswordModel> {
  final ChangePasswordRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ChangePasswordModel>> execute(
      ChangePasswordRequest input) async {
    return await _repository.changePassword(
      input,
    );
  }
}
