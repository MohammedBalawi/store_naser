import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/terms/data/response/terms_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class TermsRemoteDataSource {
  Future<TermsResponse> terms();
}

class TermsRemoteDataSourceImplement implements TermsRemoteDataSource {
  AppService appService;

  TermsRemoteDataSourceImplement(this.appService);

  @override
  Future<TermsResponse> terms() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return TermsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.terms,
          ),
        ),
      );
    }
    return await appService.terms();
  }
}
