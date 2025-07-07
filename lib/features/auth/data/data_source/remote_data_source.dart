import 'package:app_mobile/features/auth/data/request/register_request.dart';
import 'package:app_mobile/features/auth/data/response/register_response.dart';

import '../../../../core/network/app_api.dart';
import '../request/login_request.dart';
import '../response/login_response.dart';

abstract class RemoteLoginDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);
}

class RemoteLoginDateSourceImplement implements RemoteLoginDataSource {
  AppService _appService;

  RemoteLoginDateSourceImplement(this._appService);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _appService.login(loginRequest.identifier, loginRequest.password);
  }
}

abstract class RemoteRegisterDataSource {
  Future<RegisterResponse> register(RegisterRequest registerRequest);
}

class RemoteRegisterDateSourceImplement implements RemoteRegisterDataSource {
  AppService _AppService;

  RemoteRegisterDateSourceImplement(this._AppService);

  @override
  Future<RegisterResponse> register(RegisterRequest registerRequest) async {
    return await _AppService.register(
        registerRequest.fullName,
        registerRequest.email,
        registerRequest.phone,
        registerRequest.password,
        registerRequest.confirmPassword);
  }
}
