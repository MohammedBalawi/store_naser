import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/orders/data/repository/finished_order_repository.dart';
import 'package:app_mobile/features/orders/data/request/finished_order_request.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_model.dart';
import '../../../../core/error_handler/failure.dart';

class FinishedOrderUseCase
    implements BaseUseCase<FinishedOrderRequest, FinishedOrderModel> {
  final FinishedOrderRepository _repository;

  FinishedOrderUseCase(this._repository);

  @override
  Future<Either<Failure, FinishedOrderModel>> execute(
      FinishedOrderRequest input) async {
    return await _repository.orders(
      input,
    );
  }
}
