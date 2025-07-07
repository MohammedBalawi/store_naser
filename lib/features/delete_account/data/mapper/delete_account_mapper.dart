import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/delete_account/data/response/delete_account_response.dart';
import 'package:app_mobile/features/delete_account/domain/model/delete_account_model.dart';

extension DeleteAccountMapper on DeleteAccountResponse {
  DeleteAccountModel toDomain() => DeleteAccountModel(
        status: status.onNull(),
      );
}