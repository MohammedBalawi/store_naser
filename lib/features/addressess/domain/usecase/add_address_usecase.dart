import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/addressess/data/repository/add_address_repository.dart';
import 'package:app_mobile/features/addressess/data/request/add_address_request.dart';
import 'package:app_mobile/features/addressess/domain/model/add_address_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';

class AddAddressUseCase
    implements BaseUseCase<AddAddressRequest, AddAddressModel> {
  final AddAddressRepository _repository;

  AddAddressUseCase(this._repository);

  @override
  Future<Either<Failure, AddAddressModel>> execute(
      AddAddressRequest input) async {
    return await _repository.addAddress(
      input,
    );
  }
}
