import 'package:app_mobile/features/terms/data/mapper/terms_data_mapper.dart';
import 'package:app_mobile/features/terms/data/response/terms_response.dart';
import 'package:app_mobile/features/terms/domain/model/terms_model.dart';

extension TermsMapper on TermsResponse {
  TermsModel toDomain() => TermsModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
