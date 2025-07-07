import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/chats/data/response/send_message_response.dart';
import 'package:app_mobile/features/chats/domain/model/send_message_model.dart';

extension SendMessageMapper on SendMessageResponse {
  SendMessageModel toDomain() => SendMessageModel(
        status: status.onNull(),
      );
}
