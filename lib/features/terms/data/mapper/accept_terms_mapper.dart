import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/terms/data/response/accept_terms_response.dart';
import 'package:app_mobile/features/terms/domain/model/accept_terms_model.dart';

extension AcceptTermsMapper on AcceptTermsResponse {
  AcceptTermsModel toDomain() => AcceptTermsModel(
        status: status.onNull(),
      );
}
