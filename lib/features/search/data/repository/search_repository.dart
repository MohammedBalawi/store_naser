import 'package:app_mobile/features/search/data/data_source/search_data_source.dart';
import 'package:app_mobile/features/search/data/mapper/search_mapper.dart';
import 'package:app_mobile/features/search/data/request/search_request.dart';
import 'package:app_mobile/features/search/domain/model/search_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchModel>> search(SearchRequest request);
}

class SearchRepositoryImplement implements SearchRepository {
  SearchDataSource remoteDataSource;
  NetworkInfo networkInfo;

  SearchRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, SearchModel>> search(SearchRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.search(
          request,
        );
        return Right(
          response.toDomain(),
        );
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(Failure(ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION));
    }
  }
}
