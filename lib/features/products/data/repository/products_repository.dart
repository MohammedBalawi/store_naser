import 'package:app_mobile/features/products/data/data_source/products_data_source.dart';
import 'package:app_mobile/features/products/data/mapper/products_mapper.dart';
import 'package:app_mobile/features/products/domain/model/products_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class ProductsRepository {
  Future<Either<Failure, ProductsModel>> products();
}

class ProductsRepositoryImplement implements ProductsRepository {
  ProductsDataSource remoteDataSource;
  NetworkInfo networkInfo;

  ProductsRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, ProductsModel>> products() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.products();
        return Right(
          response.toDomain(),
        );
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
