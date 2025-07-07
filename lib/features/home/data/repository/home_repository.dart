// import 'package:dartz/dartz.dart';
// import 'package:app_mobile/features/home/data/data_source/home_data_source.dart';
// import 'package:app_mobile/features/home/data/mapper/home_mapper.dart';
// import 'package:app_mobile/features/home/domain/model/home_model.dart';
// import '../../../../core/error_handler/error_handler.dart';
// import '../../../../core/error_handler/failure.dart';
// import '../../../../core/error_handler/response_code.dart';
// import '../../../../core/internet_checker/interent_checker.dart';
// import '../../../../core/resources/manager_strings.dart';
//
// abstract class HomeRepository {
//   Future<Either<Failure, HomeModel>> home();
// }
//
// class HomeRepositoryImplement implements HomeRepository {
//   HomeRemoteDataSource remoteDataSource;
//   NetworkInfo networkInfo;
//
//   HomeRepositoryImplement(this.networkInfo, this.remoteDataSource);
//
//   @override
//   Future<Either<Failure, HomeModel>> home() async {
//     if (await networkInfo.isConnected) {
//       /// Its connected
//       try {
//         final response = await remoteDataSource.home();
//         // return Right(response.toDomain());
//       } catch (e) {
//         return Left(ErrorHandler.handle(e).failure);
//       }
//     } else {
//       return Left(
//         Failure(
//           ResponseCode.noInternetConnection,
//           ManagerStrings.NO_INTERNT_CONNECTION,
//         ),
//       );
//     }
//   }
// }
