import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/favorite/data/response/favorite_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class FavoriteRemoteDataSource {
  Future<FavoriteResponse> favorite();
}

class FavoriteRemoteDataSourceImplement implements FavoriteRemoteDataSource {
  AppService appService;

  FavoriteRemoteDataSourceImplement(this.appService);

  @override
  Future<FavoriteResponse> favorite() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return FavoriteResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.favorite,
          ),
        ),
      );
    }
    return await appService.favorite();
  }
}
