import 'package:app_mobile/features/addressess/data/response/address_area_id_response.dart';
import 'package:app_mobile/features/addressess/data/response/address_gov_id_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'address_response.g.dart';

@JsonSerializable()
class AddressResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.title)
  String? type;
  @JsonKey(name: ResponseConstants.street)
  String? street;
  @JsonKey(name: ResponseConstants.zipCode)
  String? postalCode;
  @JsonKey(name: ResponseConstants.isDefault)
  int? isDefault;
  @JsonKey(name: ResponseConstants.lat)
  String? lat;
  @JsonKey(name: ResponseConstants.lang)
  String? lang;
  @JsonKey(name: ResponseConstants.mobile)
  String? mobile;
  @JsonKey(name: ResponseConstants.areaId)
  AddressAreaIdResponse? areaId;
  @JsonKey(name: ResponseConstants.govId)
  AddressGovIdResponse? govId;

  AddressResponse({
    this.id,
    this.type,
    this.street,
    this.postalCode,
    this.isDefault,
    this.lat,
    this.lang,
    this.mobile,
    this.areaId,
    this.govId,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseToJson(this);
}
