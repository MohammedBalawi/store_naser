import 'package:app_mobile/features/products/data/response/products_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class ProductsDataSource {
  Future<ProductsResponse> products();
}

class ProductsRemoteDataSourceImplement implements ProductsDataSource {
  AppService appService;

  ProductsRemoteDataSourceImplement(this.appService);

  @override
  Future<ProductsResponse> products() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return ProductsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.products,
          ),
        ),
      );
    }
    return await appService.products();
  }
}
