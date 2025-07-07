import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/terms/data/response/accept_terms_response.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../../../../core/resources/manager_mockup.dart';

abstract class AcceptTermsRemoteDataSource {
  Future<AcceptTermsResponse> accept();
}

class AcceptTermsRemoteDataSourceImplement implements AcceptTermsRemoteDataSource {
  AppService appService;

  AcceptTermsRemoteDataSourceImplement(this.appService);

  @override
  Future<AcceptTermsResponse> accept() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return AcceptTermsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.acceptTerms,
          ),
        ),
      );
    }
    return await appService.acceptTerms();
  }
}
