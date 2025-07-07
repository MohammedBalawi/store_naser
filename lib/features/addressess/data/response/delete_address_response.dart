import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'delete_address_response.g.dart';

@JsonSerializable()
class DeleteAddressResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  DeleteAddressResponse({
    this.status,
  });

  factory DeleteAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAddressResponseToJson(this);
}
