import 'package:app_mobile/features/product_details/data/repository/add_rate_repository.dart';
import 'package:app_mobile/features/product_details/data/request/add_rate_request.dart';
import 'package:app_mobile/features/product_details/domain/model/add_rate_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class AddRateUseCase
    implements BaseUseCase<AddRateRequest, AddRateModel> {
  final AddRateRepository _repository;

  AddRateUseCase(this._repository);

  @override
  Future<Either<Failure, AddRateModel>> execute(
    AddRateRequest input,
  ) async {
    return await _repository.addRate(
      input,
    );
  }
}
