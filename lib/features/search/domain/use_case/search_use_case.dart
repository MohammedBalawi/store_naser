import 'package:app_mobile/features/search/data/repository/search_repository.dart';
import 'package:app_mobile/features/search/data/request/search_request.dart';
import 'package:app_mobile/features/search/domain/model/search_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import '../../../../core/error_handler/failure.dart';

class SearchUseCase implements BaseUseCase<SearchRequest, SearchModel> {
  final SearchRepository _repository;

  SearchUseCase(this._repository);

  @override
  Future<Either<Failure, SearchModel>> execute(SearchRequest request) async {
    return await _repository.search(
      request,
    );
  }
}
