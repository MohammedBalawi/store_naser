import 'package:app_mobile/features/product_details/data/data_source/product_details_data_source.dart';
import 'package:app_mobile/features/product_details/data/mapper/product_details_mapper.dart';
import 'package:app_mobile/features/product_details/data/request/product_details_request.dart';
import 'package:app_mobile/features/product_details/domain/model/product_details_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsModel>> details(
    ProductDetailsRequest request,
  );
}

class ProductDetailsRepositoryImplement implements ProductDetailsRepository {
  ProductDetailsDataSource remoteDataSource;
  NetworkInfo networkInfo;

  ProductDetailsRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, ProductDetailsModel>> details(
    ProductDetailsRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.details(
          request,
        );
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
