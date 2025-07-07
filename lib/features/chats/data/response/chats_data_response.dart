import 'package:app_mobile/features/chats/data/response/chat_user_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'chats_data_response.g.dart';

@JsonSerializable()
class ChatsDataResponse {
  @JsonKey(name: ResponseConstants.id)
  String? id;
  @JsonKey(name: ResponseConstants.user)
  ChatUserResponse? user;

  ChatsDataResponse({
    this.id,
    this.user,
  });

  factory ChatsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsDataResponseToJson(this);
}
