import 'package:app_mobile/features/chats/data/response/new_chat_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';
import '../request/new_chat_request.dart';

abstract class NewChatDataSource {
  Future<NewChatResponse> newChat(NewChatRequest request);
}

class NewChatRemoteDataSourceImplement implements NewChatDataSource {
  AppService appService;

  NewChatRemoteDataSourceImplement(this.appService);

  @override
  Future<NewChatResponse> newChat(NewChatRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return NewChatResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.newChat,
          ),
        ),
      );
    }
    return await appService.newChat(
      request.merchantId,
    );
  }
}
