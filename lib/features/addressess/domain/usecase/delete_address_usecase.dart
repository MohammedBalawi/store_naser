import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/addressess/data/repository/delete_address_repository.dart';
import 'package:app_mobile/features/addressess/data/request/delete_address_request.dart';
import 'package:app_mobile/features/addressess/domain/model/delete_address_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';

class DeleteAddressUseCase
    implements BaseUseCase<DeleteAddressRequest, DeleteAddressModel> {
  final DeleteAddressRepository _repository;

  DeleteAddressUseCase(this._repository);

  @override
  Future<Either<Failure, DeleteAddressModel>> execute(
      DeleteAddressRequest input) async {
    return await _repository.deleteAddress(
      input,
    );
  }
}
