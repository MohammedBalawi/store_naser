import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'home_banner_response.g.dart';

@JsonSerializable()
class HomeBannerResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  String? title;
  String? image;

  HomeBannerResponse({
    this.id,
    this.title,
    this.image,
  });

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerResponseToJson(this);
}
