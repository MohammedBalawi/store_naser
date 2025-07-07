import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/terms/data/repository/accept_terms_repository.dart';
import 'package:app_mobile/features/terms/domain/model/accept_terms_model.dart';
import '../../../../core/error_handler/failure.dart';

class AcceptTermsUseCase implements BaseGetUseCase<AcceptTermsModel> {
  final AcceptTermsRepository _repository;

  AcceptTermsUseCase(this._repository);

  @override
  Future<Either<Failure, AcceptTermsModel>> execute() async {
    return await _repository.accept();
  }
}
