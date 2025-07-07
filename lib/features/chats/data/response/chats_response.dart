import 'package:app_mobile/features/chats/data/response/chats_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'chats_response.g.dart';

@JsonSerializable()
class ChatsResponse {
  @JsonKey(name: ResponseConstants.chats)
  List<ChatsDataResponse>? chats;

  ChatsResponse({
    this.chats,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsResponseToJson(this);
}
