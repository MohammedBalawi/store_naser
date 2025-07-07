import 'package:app_mobile/core/network/dio_factory.dart';
import 'package:app_mobile/features/cart/data/request/cart_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/cart/data/response/cart_response.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';
import '../../../../core/service/env_service.dart';

abstract class CartRemoteDataSource {
  Future<CartResponse> cart(CartRequest request);
}

class CartRemoteDataSourceImplement implements CartRemoteDataSource {
  AppService appService;

  CartRemoteDataSourceImplement(this.appService);

  @override
  Future<CartResponse> cart(CartRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return CartResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.cart,
          ),
        ),
      );
    }
    return await appService.cart(
      request.ids,
    );
  }
}
