import '../../../../core/error_handler/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../data/repository/login_repository.dart';
import '../../data/request/login_request.dart';
import '../models/login_model.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginRequest, Login> {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Login>> execute(LoginRequest input) async {
    return await _repository.login(
      input,
    );
  }
}
