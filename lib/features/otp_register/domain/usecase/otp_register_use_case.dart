import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/otp_register/data/request/otp_register_request.dart';
import 'package:app_mobile/features/otp_register/domain/repositroy/otp_register_repositroy.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failure.dart';
import '../models/otp_register.dart';

class OtpRegisterInput {
  String email;
  String password;
  String otp;

  OtpRegisterInput({
    required this.email,
    required this.password,
    required this.otp,
  });
}

class OtpRegisterUseCase extends BaseUseCase<OtpRegisterInput, OtpRegister> {
  final OtpRegisterRepositroy _repository;

  OtpRegisterUseCase(this._repository);

  @override
  Future<Either<Failure, OtpRegister>> execute(OtpRegisterInput input) async {
    return await _repository.otpRegister(
      OtpRegisterRequest(
        email: input.email,
        password: input.password,
        otp: input.otp,
      ),
    );
  }
}
