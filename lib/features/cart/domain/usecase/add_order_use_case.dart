import 'package:app_mobile/features/cart/data/repository/add_order_repository.dart';
import 'package:app_mobile/features/cart/data/request/add_order_request.dart';
import 'package:app_mobile/features/cart/domain/model/add_order_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class AddOrderUseCase implements BaseUseCase<AddOrderRequest, AddOrderModel> {
  final AddOrderRepository _repository;

  AddOrderUseCase(this._repository);

  @override
  Future<Either<Failure, AddOrderModel>> execute(
      AddOrderRequest request) async {
    return await _repository.addOrder(
      request,
    );
  }
}
