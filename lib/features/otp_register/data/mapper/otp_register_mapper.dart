import 'package:app_mobile/core/extensions/extensions.dart';
import '../../domain/models/otp_register.dart';
import '../response/otp_register_response.dart';

extension OtpRegisterMapper on OtpRegisterResponse {
  OtpRegister toDomain() {
    return OtpRegister(
      status: status.onNull(),
    );
  }
}
