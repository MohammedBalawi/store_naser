import '../../../../core/network/app_api.dart';
import '../request/otp_register_request.dart';
import '../response/otp_register_response.dart';

abstract class OtpRegisterRemoteDataSource {
  Future<OtpRegisterResponse> otpRegister(
      OtpRegisterRequest otpRegisterRequest);
}

class OtpRegisterRemoteDataSourceImpl implements OtpRegisterRemoteDataSource {
  AppService _appService;

  OtpRegisterRemoteDataSourceImpl(this._appService);

  @override
  Future<OtpRegisterResponse> otpRegister(
      OtpRegisterRequest otpRegisterRequest) async {
    return await _appService.otpRegister(
      otpRegisterRequest.email,
      otpRegisterRequest.password,
      otpRegisterRequest.otp,
    );
  }
}
