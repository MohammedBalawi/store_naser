import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'address_response.dart';

part 'addresses_response.g.dart';

@JsonSerializable()
class AddressesResponse {
  @JsonKey(name: ResponseConstants.addresses)
  List<AddressResponse>? data;

  AddressesResponse({
    this.data,
  });

  factory AddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddressesResponseToJson(this);
}
