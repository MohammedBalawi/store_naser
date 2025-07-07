import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/cart/data/repository/cart_repository.dart';
import 'package:app_mobile/features/cart/domain/model/cart_model.dart';
import '../../../../core/error_handler/failure.dart';
import '../../data/request/cart_request.dart';

class CartUseCase implements BaseUseCase<CartRequest, CartModel> {
  final CartRepository _repository;

  CartUseCase(this._repository);

  @override
  Future<Either<Failure, CartModel>> execute(CartRequest request) async {
    return await _repository.cart(request);
  }
}
