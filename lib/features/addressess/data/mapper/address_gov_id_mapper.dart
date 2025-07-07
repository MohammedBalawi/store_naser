import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/address_gov_id_response.dart';
import 'package:app_mobile/features/addressess/domain/model/address_gov_id_model.dart';

extension AddressGovIdMapper on AddressGovIdResponse {
  AddressGovIdModel toDomain() => AddressGovIdModel(
        id: id.onNull(),
        name: name.onNull(),
      );
}
