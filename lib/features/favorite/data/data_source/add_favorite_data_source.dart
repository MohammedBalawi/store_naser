import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/favorite/data/request/add_favorite_request.dart';
import 'package:app_mobile/features/favorite/data/response/add_favorite_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class AddFavoriteRemoteDataSource {
  Future<AddFavoriteResponse> addFavorite(AddFavoriteRequest request);
}

class AddFavoriteRemoteDataSourceImplement
    implements AddFavoriteRemoteDataSource {
  AppService appService;

  AddFavoriteRemoteDataSourceImplement(this.appService);

  @override
  Future<AddFavoriteResponse> addFavorite(AddFavoriteRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AddFavoriteResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.addFavorite,
          ),
        ),
      );
    }
    return await appService.addFavorite(
      request.id,
    );
  }
}
