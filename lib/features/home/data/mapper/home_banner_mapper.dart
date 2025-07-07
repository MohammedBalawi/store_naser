import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/home/data/response/home_banner_response.dart';
import 'package:app_mobile/features/home/domain/model/home_banner_model.dart';

extension HomeBannerMapper on HomeBannerResponse {
  HomeBannerModel toDomain() => HomeBannerModel(
        id: id.onNull().toString(),
    title: title.onNull(),
    imageUrl: image.onNull(),
      );
}
