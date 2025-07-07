import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/forget_password/data/response/forget_password_response.dart';
import 'package:app_mobile/features/forget_password/domain/models/forget_password.dart';

extension ForgetPasswordMapper on ForgetPasswordResponse{
  toDomain() =>
      ForgetPassword(status: this.status!.onNull());
}