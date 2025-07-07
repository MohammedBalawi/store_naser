import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/change_password/data/response/change_password_response.dart';
import 'package:app_mobile/features/change_password/domain/model/change_password_model.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordModel toDomain() => ChangePasswordModel(
        status: status.onNull(),
      );
}
