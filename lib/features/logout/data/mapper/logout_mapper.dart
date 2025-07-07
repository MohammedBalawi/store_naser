import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/auth/data/response/logout_response.dart';
import 'package:app_mobile/features/logout/domain/model/logout_model.dart';

extension LogoutMapper on LogoutResponse {
  LogoutModel toDomain() => LogoutModel(
    status: status.onNull(),
    message: 'تم تسجيل الخروج بنجاح',
  );
}

