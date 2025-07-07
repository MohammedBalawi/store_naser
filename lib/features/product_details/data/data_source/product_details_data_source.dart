import 'package:app_mobile/features/product_details/data/request/product_details_request.dart';
import 'package:app_mobile/features/product_details/data/response/product_details_response.dart';
import '../../../../core/network/app_api.dart';

abstract class ProductDetailsDataSource {
  Future<ProductDetailsResponse> details(
    ProductDetailsRequest request,
  );
}

class ProductDetailsRemoteDataSourceImplement
    implements ProductDetailsDataSource {
  AppService appService;

  ProductDetailsRemoteDataSourceImplement(this.appService);

  @override
  Future<ProductDetailsResponse> details(ProductDetailsRequest request) async {
    return await appService.productDetails(
      request.id,
    );
  }
}
