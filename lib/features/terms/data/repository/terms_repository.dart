import 'package:dartz/dartz.dart';
import 'package:app_mobile/features/terms/data/data_source/terms_data_source.dart';
import 'package:app_mobile/features/terms/data/mapper/terms_mapper.dart';
import 'package:app_mobile/features/terms/domain/model/terms_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/resources/manager_strings.dart';

abstract class TermsRepository {
  Future<Either<Failure, TermsModel>> terms();
}

class TermsRepositoryImplement implements TermsRepository {
  TermsRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;

  TermsRepositoryImplement(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, TermsModel>> terms() async {
    if (await networkInfo.isConnected) {
      /// Its connected
      try {
        final response = await remoteDataSource.terms();
        return Right(response.toDomain());
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(Failure(ResponseCode.noInternetConnection,
          ManagerStrings.NO_INTERNT_CONNECTION));
    }
  }
}
