import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/addresses_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class AddressesRemoteDataSource {
  Future<AddressesResponse> addresses();
}

class AddressesRemoteDataSourceImplement
    implements AddressesRemoteDataSource {
  AppService appService;

  AddressesRemoteDataSourceImplement(this.appService);

  @override
  Future<AddressesResponse> addresses() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AddressesResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.addresses,
          ),
        ),
      );
    }
    return await appService.addresses();
  }
}
