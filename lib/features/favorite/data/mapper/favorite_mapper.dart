import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/favorite/data/response/favorite_response.dart';
import 'package:app_mobile/features/favorite/domain/model/favorite_model.dart';

extension FavoriteMapper on FavoriteResponse {
  FavoriteModel toDomain() => FavoriteModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
