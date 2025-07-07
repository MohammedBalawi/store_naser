import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/delete_account/data/data_source/delete_account_data_source.dart';
import 'package:app_mobile/features/delete_account/data/mapper/delete_account_mapper.dart';
import 'package:app_mobile/features/delete_account/domain/model/delete_account_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class DeleteAccountRepository {
  Future<Either<Failure, DeleteAccountModel>> deleteAccount();
}

class DeleteAccountRepositoryImplement implements DeleteAccountRepository {
  DeleteAccountRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  DeleteAccountRepositoryImplement(
    this.networkInfo,
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.deleteAccount();
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
