import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/request/add_address_request.dart';
import 'package:app_mobile/features/addressess/data/response/add_address_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class AddAddressRemoteDataSource {
  Future<AddAddressResponse> addAddress(AddAddressRequest request);
}

class AddAddressRemoteDataSourceImplement
    implements AddAddressRemoteDataSource {
  AppService appService;

  AddAddressRemoteDataSourceImplement(this.appService);

  @override
  Future<AddAddressResponse> addAddress(AddAddressRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AddAddressResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.addAddress,
          ),
        ),
      );
    }
    return await appService.addAddress(
      request.type,
      request.city,
      request.state,
      request.street,
      request.postalCode,
      request.useDefault ? 1 : 0,
      request.mobile,
      request.lat,
      request.lang,
    );
  }
}
