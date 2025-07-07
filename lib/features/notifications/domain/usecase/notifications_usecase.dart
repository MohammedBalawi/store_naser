import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/notifications/data/repository/notifications_repository.dart';
import 'package:app_mobile/features/notifications/domain/models/notifications_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';

class NotificationsUseCase implements BaseGetUseCase<NotificationsModel> {
  final NotificationsRepository _repository;

  NotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsModel>> execute() async {
    return await _repository.notifications();
  }
}
