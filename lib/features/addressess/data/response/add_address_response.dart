import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'add_address_response.g.dart';

@JsonSerializable()
class AddAddressResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  AddAddressResponse({
    this.status,
  });

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressResponseToJson(this);
}
