import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/auth/data/request/register_request.dart';
import 'package:app_mobile/features/auth/domain/models/register_model.dart';
import 'package:app_mobile/features/auth/domain/repository/register_repository.dart';
import '../../../../core/error_handler/failure.dart';

class RegisterUseCase implements BaseUseCase<RegisterUseCaseInput, Register> {
  final RegisterRepository _repository;
  RegisterUseCase(this._repository);
  @override
  Future<Either<Failure, Register>> execute(RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
        confirmPassword: input.confirmPassword));
  }
}

class RegisterUseCaseInput {
  String fullName;
  String email;
  String phone;
  String password;
  String confirmPassword;
  RegisterUseCaseInput({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}
