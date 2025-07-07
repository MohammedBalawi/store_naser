import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/addressess/domain/model/addresses_model.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../../../core/error_handler/failure.dart';
import '../../data/repository/addresses_repository.dart';

class AddressesUseCase implements BaseGetUseCase<AddressesModel> {
  final AddressesRepository _repository;

  AddressesUseCase(this._repository);

  @override
  Future<Either<Failure, AddressesModel>> execute() async {
    return await _repository.addresses();
  }
}
