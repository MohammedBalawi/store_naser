import 'package:app_mobile/features/auth/data/request/fvm_token_request.dart';
import 'package:app_mobile/features/auth/domain/models/fcm_token_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error_handler/failure.dart';

abstract class FcmTokenRepository {
  Future<Either<Failure, FcmTokenModel>> fcmToken(
    FcmTokenRequest fcmTokenRequest,
  );
}
