import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'chat_user_response.g.dart';

@JsonSerializable()
class ChatUserResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.image)
  String? image;

  ChatUserResponse({
    this.id,
    this.name,
    this.image,
  });

  factory ChatUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserResponseToJson(this);
}
