import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/usecase/base_usecase.dart';
import 'package:app_mobile/features/terms/data/repository/terms_repository.dart';
import 'package:app_mobile/features/terms/domain/model/terms_model.dart';
import '../../../../core/error_handler/failure.dart';

class TermsUseCase implements BaseGetUseCase<TermsModel> {
  final TermsRepository _repository;

  TermsUseCase(this._repository);

  @override
  Future<Either<Failure, TermsModel>> execute() async {
    return await _repository.terms();
  }
}
