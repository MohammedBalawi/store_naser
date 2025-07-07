import 'package:dartz/dartz.dart';

import '../../../../core/error_handler/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../data/repository/logout_repository.dart';
import '../model/logout_model.dart';

class LogoutUseCase implements BaseGetUseCase<LogoutModel> {
  final LogoutRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutModel>> execute() async {
    return await _repository.logout();
  }
}
