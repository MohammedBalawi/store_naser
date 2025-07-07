import 'package:app_mobile/features/products/data/repository/products_repository.dart';
import 'package:app_mobile/features/products/domain/model/products_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class ProductsUseCase implements BaseGetUseCase<ProductsModel> {
  final ProductsRepository _repository;

  ProductsUseCase(this._repository);

  @override
  Future<Either<Failure, ProductsModel>> execute() async {
    return await _repository.products();
  }
}
