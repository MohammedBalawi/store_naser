import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/mapper/address_area_id_mapper.dart';
import 'package:app_mobile/features/addressess/data/mapper/address_gov_id_mapper.dart';
import 'package:app_mobile/features/addressess/data/response/address_response.dart';
import 'package:app_mobile/features/addressess/domain/model/address_model.dart';

extension AddressMapper on AddressResponse {
  AddressModel toDomain() {
        return AddressModel(
              id: id.onNull(),
              type: type.onNull(),
              street: street.onNull(),
              postalCode: postalCode.onNull(),
              lat: lat.onNull(),
              lang: lang.onNull(),
              mobile: mobile.onNull(),
              areaId: areaId!.toDomain(),
              govId: govId!.toDomain(), isDefault: true,
        );
  }
}
