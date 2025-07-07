import 'package:app_mobile/features/otp_register/data/mapper/otp_register_mapper.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../domain/models/otp_register.dart';
import '../../domain/repositroy/otp_register_repositroy.dart';
import '../data_souces/otp_register_remote_data_source.dart';
import '../request/otp_register_request.dart';

class OtpRegisterRepositroyImpl extends OtpRegisterRepositroy {
  OtpRegisterRemoteDataSource _otpRegisterDataSource;
  NetworkInfo _networkInfo;

  OtpRegisterRepositroyImpl(
    this._networkInfo,
    this._otpRegisterDataSource,
  );

  @override
  Future<Either<Failure, OtpRegister>> otpRegister(
      OtpRegisterRequest otpRegisterRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _otpRegisterDataSource.otpRegister(
          otpRegisterRequest,
        );
        return Right(response.toDomain());
      } catch (e) {
        return Left(
          ErrorHandler.handle(e).failure,
        );
      }
    } else {
      return Left(
        Failure(
          ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION,
        ),
      );
    }
  }
}
