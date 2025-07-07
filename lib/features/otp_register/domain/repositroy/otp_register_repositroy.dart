import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failure.dart';
import '../../data/request/otp_register_request.dart';
import '../models/otp_register.dart';

abstract class OtpRegisterRepositroy {
  Future<Either<Failure, OtpRegister>> otpRegister(
    OtpRegisterRequest otpRegisterRequest,
  );
}
