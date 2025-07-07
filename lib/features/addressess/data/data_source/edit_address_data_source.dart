import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/request/edit_address_request.dart';
import 'package:app_mobile/features/addressess/data/response/edit_address_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class EditAddressRemoteDataSource {
  Future<EditAddressResponse> editAddress(
    EditAddressRequest request,
  );
}

class EditAddressRemoteDataSourceImplement
    implements EditAddressRemoteDataSource {
  AppService appService;

  EditAddressRemoteDataSourceImplement(this.appService);

  @override
  Future<EditAddressResponse> editAddress(EditAddressRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return EditAddressResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.editAddress,
          ),
        ),
      );
    }
    return await appService.editAddress(
      request.id,
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
