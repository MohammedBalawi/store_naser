import 'package:app_mobile/features/auth/data/request/register_request.dart';
import 'package:app_mobile/features/auth/domain/models/register_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failure.dart';

abstract class RegisterRepository{
  Future<Either<Failure,Register>> register(RegisterRequest registerRequest);
}