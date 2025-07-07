import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/edit_address_response.dart';
import 'package:app_mobile/features/addressess/domain/model/edit_address_model.dart';

extension EditAddressMapper on EditAddressResponse {
  EditAddressModel toDomain() => EditAddressModel(
        status: status.onNull(),
      );
}
