import 'package:app_mobile/features/product_details/data/repository/product_details_repository.dart';
import 'package:app_mobile/features/product_details/data/request/product_details_request.dart';
import 'package:app_mobile/features/product_details/domain/model/product_details_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class ProductDetailsUseCase
    implements BaseUseCase<ProductDetailsRequest, ProductDetailsModel> {
  final ProductDetailsRepository _repository;

  ProductDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ProductDetailsModel>> execute(
      ProductDetailsRequest input) async {
    return await _repository.details(
      input,
    );
  }
}
