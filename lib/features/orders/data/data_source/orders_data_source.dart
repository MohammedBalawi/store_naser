import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/response/orders_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class OrdersRemoteDataSource {
  Future<OrdersResponse> orders();
}

class OrdersRemoteDataSourceImplement implements OrdersRemoteDataSource {
  AppService appService;

  OrdersRemoteDataSourceImplement(this.appService);

  @override
  Future<OrdersResponse> orders() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return OrdersResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.orders,
          ),
        ),
      );
    }
    return await appService.orders();
  }
}
