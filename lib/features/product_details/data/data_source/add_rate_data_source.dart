import 'package:app_mobile/features/product_details/data/response/add_rate_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';
import '../request/add_rate_request.dart';

abstract class AddRateDataSource {
  Future<AddRateResponse> addRate(
      AddRateRequest request,
      );
}

class AddRateRemoteDataSourceImplement
    implements AddRateDataSource {
  AppService appService;

  AddRateRemoteDataSourceImplement(this.appService);

  @override
  Future<AddRateResponse> addRate(AddRateRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AddRateResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.productDetails,
          ),
        ),
      );
    }
    return await appService.addRate(
      request.productId,
      request.rate,
      request.title,
      request.comment,
    );
  }
}
