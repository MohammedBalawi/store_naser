import 'package:app_mobile/features/categories/data/mapper/main_categories_mapper.dart';
import 'package:app_mobile/features/categories/domain/model/main_categories_model.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/categories/data/data_source/categories_data_source.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, MainCategoriesModel>> categories();
}

class CategoriesRepositoryImplement implements CategoriesRepository {
  CategoriesRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  CategoriesRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, MainCategoriesModel>> categories() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.categories();
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
