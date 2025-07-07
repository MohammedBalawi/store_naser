import 'package:app_mobile/core/internet_checker/interent_checker.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/auth/data/data_source/remote_data_source.dart';
import 'package:app_mobile/features/auth/data/mapper/register_mapper.dart';
import 'package:app_mobile/features/auth/data/request/register_request.dart';
import 'package:app_mobile/features/auth/domain/models/register_model.dart';
import 'package:app_mobile/features/auth/domain/repository/register_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error_handler/failure.dart';
import '../../../../core/error_handler/response_code.dart';

class RegisterRepoImplement implements RegisterRepository{
  RemoteRegisterDataSource _remoteRegisterDataSource;
  NetworkInfo _networkInfo ;
  RegisterRepoImplement(this._networkInfo,this._remoteRegisterDataSource);
  @override
  Future<Either<Failure, Register>> register(RegisterRequest registerRequest) async{
      if(await _networkInfo.isConnected){
        /// Its connected
        try{
          final response = await _remoteRegisterDataSource.register(registerRequest);
          return Right(response.toDomain());

        }catch(e){
          try{
            return Left(
                Failure(ResponseCode.internalServerError, ManagerStrings.INTERNAL_SERVER_ERROR)
            );
          }catch(e){
            return Left(Failure(ResponseCode.unKnown, ManagerStrings.UNKNOWN));
          }
        }
      }else{
        return Left(Failure(ResponseCode.noInternetConnection, ManagerStrings.NO_INTERNT_CONNECTION));
      }

  }  
}