import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import '../../../../core/resources/manager_mockup.dart';
import '../request/login_request.dart';
import '../response/login_response.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

abstract class LoginRemoteDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);
}

class LoginRemoteDataSourceImplement implements LoginRemoteDataSource {
  AppService _appService;

  LoginRemoteDataSourceImplement(this._appService);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return LoginResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.login(
      loginRequest.identifier,
      loginRequest.password,
    );
  }
}
