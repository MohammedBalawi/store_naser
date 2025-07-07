import 'package:app_mobile/features/notifications/data/mapper/notification_mapper.dart';
import '../../domain/models/notifications_model.dart';
import '../response/notifications_response.dart';

extension NotificationsMapper on NotificationsResponse {
  NotificationsModel toDomain() => NotificationsModel(
      data: data!
          .map(
            (e) => e.toDomain(),
          )
          .toList());
}
