import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/notifications/data/response/notifications_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponse> notifications();
}

class NotificationsRemoteDataSourceImplement
    implements NotificationsRemoteDataSource {
  AppService appService;

  NotificationsRemoteDataSourceImplement(this.appService);

  @override
  Future<NotificationsResponse> notifications() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return NotificationsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.notifications,
          ),
        ),
      );
    }
    return await appService.notifications();
  }
}
