import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/favorite/data/repository/add_favorite_repository.dart';
import 'package:app_mobile/features/favorite/data/request/add_favorite_request.dart';
import 'package:app_mobile/features/favorite/domain/model/add_favorite_model.dart';
import '../../../../core/error_handler/failure.dart';

class AddFavoriteUseCase
    implements BaseUseCase<AddFavoriteRequest, AddFavoriteModel> {
  final AddFavoriteRepository _repository;

  AddFavoriteUseCase(this._repository);

  @override
  Future<Either<Failure, AddFavoriteModel>> execute(
      AddFavoriteRequest input) async {
    return await _repository.addFavorite(
      input,
    );
  }
}
