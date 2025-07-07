import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/logout/domain/model/logout_model.dart';
import '../../data/repository/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      return Right(LogoutModel(
        message: "تم تسجيل الخروج بنجاح",
        status: true,
      ));
    } catch (e) {
      return Left(Failure(500, 'فشل تسجيل الخروج: $e'));
    }
  }
}
