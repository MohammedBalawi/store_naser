import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:app_mobile/features/favorite/data/mapper/favorite_mapper.dart';
import 'package:app_mobile/features/favorite/domain/model/favorite_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, FavoriteModel>> favorite();
}

class FavoriteRepositoryImplement implements FavoriteRepository {
  FavoriteRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  FavoriteRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, FavoriteModel>> favorite() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.favorite();
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
