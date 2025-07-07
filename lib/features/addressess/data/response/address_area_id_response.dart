import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'address_area_id_response.g.dart';

@JsonSerializable()
class AddressAreaIdResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;

  AddressAreaIdResponse({
    this.id,
  });

  factory AddressAreaIdResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressAreaIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddressAreaIdResponseToJson(this);
}
