import 'package:app_mobile/features/categories/data/response/main_categories_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class CategoriesRemoteDataSource {
  Future<MainCategoriesResponse> categories();
}

class CategoriesRemoteDataSourceImplement implements CategoriesRemoteDataSource {
  AppService appService;

  CategoriesRemoteDataSourceImplement(this.appService);

  @override
  Future<MainCategoriesResponse> categories() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return MainCategoriesResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.categories,
          ),
        ),
      );
    }
    return await appService.categories();
  }
}
