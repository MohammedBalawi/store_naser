import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'edit_address_response.g.dart';

@JsonSerializable()
class EditAddressResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  EditAddressResponse({
    this.status,
  });

  factory EditAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$EditAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditAddressResponseToJson(this);
}
