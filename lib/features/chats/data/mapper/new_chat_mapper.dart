import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/chats/data/response/new_chat_response.dart';
import 'package:app_mobile/features/chats/domain/model/new_chat_model.dart';

extension NewChatMapper on NewChatResponse {
  NewChatModel toDomain() => NewChatModel(
        status: status.onNull(),
      );
}
