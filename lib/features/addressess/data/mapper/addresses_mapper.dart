import 'package:app_mobile/features/addressess/data/mapper/address_mapper.dart';
import 'package:app_mobile/features/addressess/data/response/addresses_response.dart';
import 'package:app_mobile/features/addressess/domain/model/addresses_model.dart';

extension AddressesMapper on AddressesResponse {
  AddressesModel toDomain() => AddressesModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
