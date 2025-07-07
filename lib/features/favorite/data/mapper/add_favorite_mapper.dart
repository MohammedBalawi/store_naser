import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/favorite/data/response/add_favorite_response.dart';
import 'package:app_mobile/features/favorite/domain/model/add_favorite_model.dart';

extension AddFavoriteMapper on AddFavoriteResponse {
  AddFavoriteModel toDomain() => AddFavoriteModel(
        status: status.onNull(),
      );
}
