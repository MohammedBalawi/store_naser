import 'package:app_mobile/features/chats/data/mapper/chat_data_mapper.dart';
import 'package:app_mobile/features/chats/data/response/chats_response.dart';
import 'package:app_mobile/features/chats/domain/model/chats_model.dart';

extension ChatsMapper on ChatsResponse {
  ChatsModel toDomain() => ChatsModel(
        chats: chats!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
