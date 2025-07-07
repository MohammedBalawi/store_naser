import 'package:app_mobile/features/search/data/request/search_request.dart';
import 'package:app_mobile/features/search/data/response/search_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import '../../../../core/resources/manager_mockup.dart';

abstract class SearchDataSource {
  Future<SearchResponse> search(SearchRequest request);
}

class SearchRemoteDataSourceImplement implements SearchDataSource {
  AppService appService;

  SearchRemoteDataSourceImplement(this.appService);

  @override
  Future<SearchResponse> search(SearchRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return SearchResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.acceptTerms,
          ),
        ),
      );
    }
    return await appService.search(
      request.filter,
    );
  }
}
