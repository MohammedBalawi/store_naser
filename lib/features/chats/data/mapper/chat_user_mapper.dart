import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/chats/data/response/chat_user_response.dart';
import 'package:app_mobile/features/chats/domain/model/chat_user_model.dart';

extension ChatUserMapper on ChatUserResponse {
  ChatUserModel toDomain() => ChatUserModel(
        id: id.onNull(),
        name: name.onNull(),
        image: image.onNull(),
      );
}
