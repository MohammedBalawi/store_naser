import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/cart/data/data_source/cart_data_source.dart';
import 'package:app_mobile/features/cart/data/mapper/cart_mapper.dart';
import 'package:app_mobile/features/cart/domain/model/cart_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';
import '../request/cart_request.dart';

abstract class CartRepository {
  Future<Either<Failure, CartModel>> cart(CartRequest request);
}

class CartRepositoryImplement implements CartRepository {
  CartRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  CartRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, CartModel>> cart(CartRequest request) async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.cart(
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
