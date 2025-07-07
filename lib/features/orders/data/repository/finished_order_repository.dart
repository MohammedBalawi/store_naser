import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/orders/data/data_source/finished_order_data_source.dart';
import 'package:app_mobile/features/orders/data/mapper/finished_order_mapper.dart';
import 'package:app_mobile/features/orders/data/request/finished_order_request.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class FinishedOrderRepository {
  Future<Either<Failure, FinishedOrderModel>> orders(FinishedOrderRequest request,);
}

class FinishedOrderRepositoryImplement implements FinishedOrderRepository {
  FinishedOrderRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  FinishedOrderRepositoryImplement(
      this.networkInfo,
      this.remoteDataSource,
      );

  @override
  Future<Either<Failure, FinishedOrderModel>> orders(FinishedOrderRequest request,) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.order(request,);
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
