import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/terms/data/response/terms_data_response.dart';
import 'package:app_mobile/features/terms/domain/model/terms_data_model.dart';

extension TermsDataMapper on TermsDataResponse {
  TermsDataModel toDomain() => TermsDataModel(
        title: title.onNull(),
        body: body.onNull(),
      );
}
