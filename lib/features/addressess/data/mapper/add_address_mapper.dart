import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/add_address_response.dart';
import 'package:app_mobile/features/addressess/domain/model/add_address_model.dart';

extension AddAddressMapper on AddAddressResponse {
  AddAddressModel toDomain() => AddAddressModel(
        status: status.onNull(),
      );
}
