import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'address_gov_id_response.g.dart';

@JsonSerializable()
class AddressGovIdResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;

  AddressGovIdResponse({
    this.id,
  });

  factory AddressGovIdResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressGovIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddressGovIdResponseToJson(this);
}
