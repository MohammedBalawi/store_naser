import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/orders/data/repository/orders_repository.dart';
import 'package:app_mobile/features/orders/domain/model/orders_model.dart';
import '../../../../core/error_handler/failure.dart';

class OrdersUseCase implements BaseGetUseCase<OrdersModel> {
  final OrdersRepository _repository;

  OrdersUseCase(this._repository);

  @override
  Future<Either<Failure, OrdersModel>> execute() async {
    return await _repository.orders();
  }
}
