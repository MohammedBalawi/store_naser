import 'package:app_mobile/features/change_password/data/request/change_password_request.dart';
import 'package:app_mobile/features/change_password/data/response/change_password_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import '../../../../core/resources/manager_mockup.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

abstract class ChangePasswordDataSource {
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
}

class ChangePasswordRemoteDataSourceImplement
    implements ChangePasswordDataSource {
  AppService _appService;

  ChangePasswordRemoteDataSourceImplement(this._appService);

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return ChangePasswordResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.changePassword(
      request.oldPassword,
      request.password,
      request.passwordConfirmation,
    );
  }
}
