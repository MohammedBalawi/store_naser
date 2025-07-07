import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/product_details/data/response/product_rate_response.dart';
import 'package:app_mobile/features/product_details/domain/model/product_rate_model.dart';

extension ProductRateMapper on ProductRateResponse {
  ProductRateModel toDomain() => ProductRateModel(
        id: id.onNull(),
        rate: rate.onNull(),
        title: title.onNull(),
        comment: comment.onNull(),
        image: image.onNull(),
        createdAt: createdAt.onNull(),
        userAvatar: userAvatar.onNull(),
        userName: userName.onNull(),
        userId: userId.onNull(),
      );
}
