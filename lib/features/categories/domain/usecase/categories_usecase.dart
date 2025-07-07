import 'package:app_mobile/features/categories/domain/model/main_categories_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/categories/data/repository/categories_repository.dart';
import '../../../../core/error_handler/failure.dart';

class CategoriesUseCase implements BaseGetUseCase<MainCategoriesModel> {
  final CategoriesRepository _repository;

  CategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, MainCategoriesModel>> execute() async {
    return await _repository.categories();
  }
}
