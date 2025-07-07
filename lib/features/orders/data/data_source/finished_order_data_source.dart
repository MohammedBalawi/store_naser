import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/request/finished_order_request.dart';
import 'package:app_mobile/features/orders/data/response/finished_order_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class FinishedOrderRemoteDataSource {
  Future<FinishedOrderResponse> order(
    FinishedOrderRequest request,
  );
}

class FinishedOrderRemoteDataSourceImplement
    implements FinishedOrderRemoteDataSource {
  AppService appService;

  FinishedOrderRemoteDataSourceImplement(this.appService);

  @override
  Future<FinishedOrderResponse> order(FinishedOrderRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return FinishedOrderResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.finishedOrder,
          ),
        ),
      );
    }
    return await appService.finishedOrder(
      request.id,
    );
  }
}
