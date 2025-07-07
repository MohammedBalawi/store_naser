import 'package:app_mobile/features/cart/data/data_source/add_order_data_source.dart';
import 'package:app_mobile/features/cart/data/mapper/add_order_mapper.dart';
import 'package:app_mobile/features/cart/data/request/add_order_request.dart';
import 'package:app_mobile/features/cart/domain/model/add_order_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, AddOrderModel>> addOrder(AddOrderRequest request);
}

class AddOrderRepositoryImplement implements AddOrderRepository {
  AddOrderDataSource remoteDataSource;
  NetworkInfo networkInfo;

  AddOrderRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, AddOrderModel>> addOrder(
      AddOrderRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.addOrder(
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
