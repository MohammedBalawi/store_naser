import 'package:app_mobile/features/cart/data/request/add_order_request.dart';
import 'package:app_mobile/features/cart/data/response/add_order_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class AddOrderDataSource {
  Future<AddOrderResponse> addOrder(AddOrderRequest request);
}

class AddOrderRemoteDataSourceImplement implements AddOrderDataSource {
  AppService appService;

  AddOrderRemoteDataSourceImplement(this.appService);

  @override
  Future<AddOrderResponse> addOrder(AddOrderRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AddOrderResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.addOrder,
          ),
        ),
      );
    }
    return await appService.addOrder(
      request.totalPrice,
      request.products,
      request.paymentType,
      request.currencyId,
      request.addressId,
      request.referenceId,
      request.couponId,
    );
  }
}
