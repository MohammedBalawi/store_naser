import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/addressess/data/repository/edit_address_repository.dart';
import 'package:app_mobile/features/addressess/data/request/edit_address_request.dart';
import 'package:app_mobile/features/addressess/domain/model/edit_address_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';

class EditAddressUseCase
    implements BaseUseCase<EditAddressRequest, EditAddressModel> {
  final EditAddressRepository _repository;

  EditAddressUseCase(this._repository);

  @override
  Future<Either<Failure, EditAddressModel>> execute(
      EditAddressRequest input) async {
    return await _repository.editAddress(
      input,
    );
  }
}
