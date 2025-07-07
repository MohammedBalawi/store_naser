import 'package:app_mobile/features/addressess/domain/model/address_area_id_model.dart';
import 'package:app_mobile/features/addressess/domain/model/address_gov_id_model.dart';

class AddressModel {
  int? id;
  String? userId;
  String? type;
  String? city;
  String? state;
  String? street;
  String? postalCode;
  bool? isDefault;
  String? lat;
  String? lang;
  String? mobile;
  AddressAreaIdModel? areaId;
  AddressGovIdModel? govId;

  AddressModel({
     this.id,
     this.userId,
     this.type,
     this.city,
     this.state,
     this.street,
     this.postalCode,
     this.isDefault,
     this.lat,
     this.lang,
     this.mobile,
     this.areaId,
     this.govId,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'],
      type: json['type'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      street: json['street'] ?? '',
      postalCode: json['postal_code'] ?? '',
      isDefault: json['is_default'] ?? false,
      lat: json['lat'] ?? '',
      lang: json['lang'] ?? '',
      mobile: json['mobile'] ?? '',
      areaId: AddressAreaIdModel(id: 0, name: ''), // dummy placeholder
      govId: AddressGovIdModel(id: 0, name: ''),   // dummy placeholder
    );
  }

}
