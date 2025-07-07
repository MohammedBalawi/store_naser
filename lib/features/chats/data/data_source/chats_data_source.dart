import 'package:app_mobile/features/chats/data/response/chats_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class ChatsDataSource {
  Future<ChatsResponse> chats();
}

class ChatsRemoteDataSourceImplement implements ChatsDataSource {
  AppService appService;

  ChatsRemoteDataSourceImplement(this.appService);

  @override
  Future<ChatsResponse> chats() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return ChatsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.chats,
          ),
        ),
      );
    }
    return await appService.chats();
  }
}
