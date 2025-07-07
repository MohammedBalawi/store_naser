import 'package:app_mobile/features/product_details/data/data_source/add_rate_data_source.dart';
import 'package:app_mobile/features/product_details/data/mapper/add_rate_mapper.dart';
import 'package:app_mobile/features/product_details/data/request/add_rate_request.dart';
import 'package:app_mobile/features/product_details/domain/model/add_rate_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class AddRateRepository {
  Future<Either<Failure, AddRateModel>> addRate(
    AddRateRequest request,
  );
}

class AddRateRepositoryImplement implements AddRateRepository {
  AddRateDataSource remoteDataSource;
  NetworkInfo networkInfo;

  AddRateRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, AddRateModel>> addRate(
    AddRateRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.addRate(
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
