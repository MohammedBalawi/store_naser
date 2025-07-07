import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/categories/data/repository/category_products_repository.dart';
import 'package:app_mobile/features/categories/data/request/category_products_request.dart';
import 'package:app_mobile/features/categories/domain/model/category_products_model.dart';
import '../../../../core/error_handler/failure.dart';

class CategoryProductsUseCase
    implements BaseUseCase<CategoryProductsRequest, CategoryProductsModel> {
  final CategoryProductsRepository _repository;

  CategoryProductsUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryProductsModel>> execute(
      CategoryProductsRequest input) async {
    return await _repository.products(
      input,
    );
  }
}
