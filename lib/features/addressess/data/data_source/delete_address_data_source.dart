import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/request/delete_address_request.dart';
import 'package:app_mobile/features/addressess/data/response/delete_address_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class DeleteAddressRemoteDataSource {
  Future<DeleteAddressResponse> deleteAddress(DeleteAddressRequest request);
}

class DeleteAddressRemoteDataSourceImplement
    implements DeleteAddressRemoteDataSource {
  AppService appService;

  DeleteAddressRemoteDataSourceImplement(this.appService);

  @override
  Future<DeleteAddressResponse> deleteAddress(
      DeleteAddressRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return DeleteAddressResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.deleteAddress,
          ),
        ),
      );
    }
    return await appService.deleteAddress(
      request.id,
    );
  }
}
