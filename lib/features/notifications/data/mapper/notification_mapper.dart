import 'package:app_mobile/core/extensions/extensions.dart';
import '../../domain/models/notification_model.dart';
import '../response/notification_response.dart';

extension NotificationMapper on NotificationResponse {
  NotificationModel toDomain() => NotificationModel(
        id: id.onNull().toString(),
        title: title.onNull(),
        description: message.onNull(),
        createdAt: null,
      );
}
