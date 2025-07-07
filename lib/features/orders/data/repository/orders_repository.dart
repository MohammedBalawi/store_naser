import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/orders/data/data_source/orders_data_source.dart';
import 'package:app_mobile/features/orders/data/mapper/orders_mapper.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../domain/model/orders_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrdersModel>> orders();
}

class OrdersRepositoryImplement implements OrdersRepository {
  OrdersRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  OrdersRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, OrdersModel>> orders() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.orders();
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
