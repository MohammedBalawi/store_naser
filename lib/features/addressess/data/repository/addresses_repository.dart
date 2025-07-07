import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/addressess/data/data_source/addresses_data_source.dart';
import 'package:app_mobile/features/addressess/data/mapper/addresses_mapper.dart';
import 'package:app_mobile/features/addressess/domain/model/addresses_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class AddressesRepository {
  Future<Either<Failure, AddressesModel>> addresses();
}

class AddressesRepositoryImplement implements AddressesRepository {
  AddressesRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  AddressesRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, AddressesModel>> addresses() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.addresses();
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
