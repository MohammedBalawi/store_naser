import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/search/data/response/search_response.dart';
import 'package:app_mobile/features/search/domain/model/search_model.dart';

extension SearchMapper on SearchResponse {
  SearchModel toDomain() => SearchModel(
        products: products!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
