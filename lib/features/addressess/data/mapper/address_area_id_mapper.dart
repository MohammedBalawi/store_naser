import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/addressess/data/response/address_area_id_response.dart';
import 'package:app_mobile/features/addressess/domain/model/address_area_id_model.dart';

extension AddressAreaIdMapper on AddressAreaIdResponse {
  AddressAreaIdModel toDomain() => AddressAreaIdModel(
        id: id.onNull(),
        name: name.onNull(),
      );
}
