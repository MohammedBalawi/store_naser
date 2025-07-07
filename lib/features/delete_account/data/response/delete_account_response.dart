import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'delete_account_response.g.dart';

@JsonSerializable()
class DeleteAccountResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  DeleteAccountResponse({
    this.status,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountResponseToJson(this);
}
