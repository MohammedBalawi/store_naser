// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:app_mobile/core/extensions/extensions.dart';
// import 'package:app_mobile/features/auth/data/response/logout_response.dart';
// import '../../../../constants/env/env_constants.dart';
// import '../../../../core/network/app_api.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' as rootBundle;
//
// import '../../../../core/resources/manager_mockup.dart';
//
// abstract class LogoutRemoteDataSource {
//   Future<LogoutResponse> logout();
// }
//
// class LogoutRemoteDataSourceImplement implements LogoutRemoteDataSource {
//   AppService appService;
//
//   LogoutRemoteDataSourceImplement(this.appService);
//
//   @override
//   Future<LogoutResponse> logout() async {
//     if (dotenv.env[EnvConstants.debug].onNullBool()) {
//       return LogoutResponse.fromJson(
//         json.decode(
//           await rootBundle.rootBundle.loadString(
//             ManagerMokUp.logout,
//           ),
//         ),
//       );
//     }
//     return await appService.logout();
//   }
// }
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/features/logout/data/response/logout_response.dart';
import '../../../../constants/env/env_constants.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import '../../../../core/resources/manager_mockup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LogoutRemoteDataSource {
  Future<LogoutResponse> logout();
}

class LogoutRemoteDataSourceImplement implements LogoutRemoteDataSource {
  @override
  Future<LogoutResponse> logout() async {
    if (dotenv.env[EnvConstants.debug]!.onNullBool()) {
      return LogoutResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.logout,
          ),
        ),
      );
    }

    await Supabase.instance.client.auth.signOut();

    return LogoutResponse(status: true);
  }

}
