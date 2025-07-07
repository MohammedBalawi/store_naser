import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/favorite/data/data_source/add_favorite_data_source.dart';
import 'package:app_mobile/features/favorite/data/mapper/add_favorite_mapper.dart';
import 'package:app_mobile/features/favorite/data/request/add_favorite_request.dart';
import 'package:app_mobile/features/favorite/domain/model/add_favorite_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class AddFavoriteRepository {
  Future<Either<Failure, AddFavoriteModel>> addFavorite(
    AddFavoriteRequest request,
  );
}

class AddFavoriteRepositoryImplement implements AddFavoriteRepository {
  AddFavoriteRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  AddFavoriteRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, AddFavoriteModel>> addFavorite(
      AddFavoriteRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.addFavorite(
          request,
        );
        return Right(response.toDomain());
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(
        Failure(
          ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION,
        ),
      );
    }
  }
}
