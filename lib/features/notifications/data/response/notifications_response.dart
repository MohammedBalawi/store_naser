import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'notification_response.dart';

part 'notifications_response.g.dart';

@JsonSerializable()
class NotificationsResponse {
  @JsonKey(name: ResponseConstants.notifications)
  List<NotificationResponse>? data;

  NotificationsResponse({
    this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}
