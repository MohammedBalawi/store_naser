import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/cart/data/response/cart_response.dart';
import 'package:app_mobile/features/cart/domain/model/cart_model.dart';

extension CartMapper on CartResponse {
  CartModel toDomain() => CartModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
