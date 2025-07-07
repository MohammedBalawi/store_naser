import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/delete_account/data/response/delete_account_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class DeleteAccountRemoteDataSource {
  Future<DeleteAccountResponse> deleteAccount();
}

class DeleteAccountRemoteDataSourceImplement
    implements DeleteAccountRemoteDataSource {
  AppService appService;

  DeleteAccountRemoteDataSourceImplement(this.appService);

  @override
  Future<DeleteAccountResponse> deleteAccount() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return DeleteAccountResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.deleteAccount,
          ),
        ),
      );
    }
    return await appService.deleteAccount();
  }
}
