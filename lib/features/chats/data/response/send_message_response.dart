import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'send_message_response.g.dart';

@JsonSerializable()
class SendMessageResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  SendMessageResponse({
    this.status,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}
