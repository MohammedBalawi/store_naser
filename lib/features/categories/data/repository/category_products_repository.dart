import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/categories/data/data_source/category_products_data_source.dart';
import 'package:app_mobile/features/categories/data/mapper/category_products_mapper.dart';
import 'package:app_mobile/features/categories/data/request/category_products_request.dart';
import 'package:app_mobile/features/categories/domain/model/category_products_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class CategoryProductsRepository {
  Future<Either<Failure, CategoryProductsModel>> products(
    CategoryProductsRequest request,
  );
}

class CategoryProductsRepositoryImplement
    implements CategoryProductsRepository {
  CategoryProductsRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  CategoryProductsRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, CategoryProductsModel>> products(
      CategoryProductsRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.products(
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
