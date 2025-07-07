import 'package:app_mobile/features/auth/data/mapper/login_data_mapper.dart';
import '../../domain/models/login_model.dart';
import '../response/login_response.dart';

extension LoginMapper on LoginResponse {
  toDomain() {
    return Login(
      user: user!.toDomain(),
    );
  }
}
