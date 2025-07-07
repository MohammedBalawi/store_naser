import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/favorite/data/repository/favorite_repository.dart';
import 'package:app_mobile/features/favorite/domain/model/favorite_model.dart';
import '../../../../core/error_handler/failure.dart';

class FavoriteUseCase implements BaseGetUseCase<FavoriteModel> {
  final FavoriteRepository _repository;

  FavoriteUseCase(this._repository);

  @override
  Future<Either<Failure, FavoriteModel>> execute() async {
    return await _repository.favorite();
  }
}
