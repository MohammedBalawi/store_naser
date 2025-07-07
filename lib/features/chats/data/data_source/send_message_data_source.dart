import 'package:app_mobile/features/chats/data/response/send_message_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';
import '../request/send_message_request.dart';

abstract class SendMessageDataSource {
  Future<SendMessageResponse> sendMessage(SendMessageRequest request);
}

class SendMessageRemoteDataSourceImplement implements SendMessageDataSource {
  AppService appService;

  SendMessageRemoteDataSourceImplement(this.appService);

  @override
  Future<SendMessageResponse> sendMessage(SendMessageRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return SendMessageResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.sendMessage,
          ),
        ),
      );
    }
    return await appService.sendMessage(
      request.message,
    );
  }
}
