import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/chats/data/mapper/chat_user_mapper.dart';
import 'package:app_mobile/features/chats/data/response/chats_data_response.dart';
import 'package:app_mobile/features/chats/domain/model/chat_data_model.dart';

extension ChatDataMapper on ChatsDataResponse {
  ChatDataModel toDomain() => ChatDataModel(
        id: id.onNull(),
        user: user!.toDomain(),
      );
}
