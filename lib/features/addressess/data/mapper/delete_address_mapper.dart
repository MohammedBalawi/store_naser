import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/delete_address_response.dart';
import 'package:app_mobile/features/addressess/domain/model/delete_address_model.dart';

extension DeleteAddressMapper on DeleteAddressResponse {
  DeleteAddressModel toDomain() => DeleteAddressModel(
        status: status.onNull(),
      );
}
