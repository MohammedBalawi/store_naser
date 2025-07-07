import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'new_chat_response.g.dart';

@JsonSerializable()
class NewChatResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  NewChatResponse({
    this.status,
  });

  factory NewChatResponse.fromJson(Map<String, dynamic> json) =>
      _$NewChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewChatResponseToJson(this);
}
