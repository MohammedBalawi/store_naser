import 'package:app_mobile/features/logout/data/response/logout_response.dart';
import 'package:app_mobile/features/logout/domain/model/logout_model.dart';

extension LogoutMapper on LogoutResponse {
  LogoutModel toDomain() {
    return LogoutModel(
      status: this.status,
      message: 'تم تسجيل الخروج بنجاح',
    );
  }
}

