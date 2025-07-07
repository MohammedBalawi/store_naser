import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/model/product_category_model.dart';
import 'package:app_mobile/core/model/product_main_category_model.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/features/product_details/data/request/product_details_request.dart';
import 'package:app_mobile/features/product_details/domain/di/di.dart';
import 'package:app_mobile/features/product_details/domain/model/product_color_image_model.dart';
import 'package:app_mobile/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/getx_storage.dart';
import '../../../favorite/presentation/controller/favorite_controller.dart';
import '../../domain/model/product_details_data_model.dart';
import '../../domain/model/product_size_model.dart';
import '../model/slider_model.dart';

class ProductDetailsController extends GetxController {
  bool isLoading = true;
  CarouselSliderController sliderController = CarouselSliderController();
  List<SliderModel> sliders = [];
  int sliderIndex = 0;
  int colorIndex = 0;
  int productSizeIndex = 0;

  ProductDetailsDataModel model = ProductDetailsDataModel(
    id: 1,
    logo: "",
    name: "",
    rate: 0,
    isRated: 0,
    inFavorite: 1,
    description: "",
    price: 0,
    discountRatio: 0,
    sellingPrice: 0,
    availableQuantity: 0,
    sku: "",
    mainCategory: ProductMainCategoryModel(
      id: 0,
      name: '',
      // icon: '',
    ),
    category: ProductCategoryModel(
      id: 0,
      name: "",
      // icon: "",
    ),
    images: [],
    rates: [],
    vendorName: '',
    vendorId: 0,
    colors: [],
    sizes: [],
  );
  List<ProductModel> related = [];

  List<ProductColorImageModel> productColors = [];

  List<ProductSizeModel> productSizes = [];

  void changeColor({
    required int index,
  }) {
    colorIndex = index;
    update();
  }

  void changeProductSize({
    required int index,
  }) {
    productSizeIndex = index;
    update();
  }

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void navigateToCart() {
    Get.offNamed(
      Routes.cart,
    );
  }

  void share() {
    //@todo: Share button here
  }

  void changeSlider(int index) {
    sliderIndex = index;
    update();
  }

  int getProductId() {
    CacheData cacheData = CacheData();
    return cacheData.getProductId();
  }

  void productDetailsRequest({required int id}) async {
    CacheData cacheData = CacheData();
    try {
      initProductDetailsRequest();
      changeIsLoading(
        value: true,
      );
      final ProductDetailsUseCase useCase = instance<ProductDetailsUseCase>();
      (await useCase.execute(ProductDetailsRequest(
        id: id,
      )))
          .fold(
        (l) {
          changeIsLoading(
            value: false,
          );
          //@todo: Call the failed toast
        },
        (r) async {
          changeIsLoading(
            value: false,
          );
          model = r.product;
          related = r.relatedProducts;
          productSizes = r.product.sizes;
          productColors = r.product.colors;
          for (int i = 0; i < r.product.images.length; i++) {
            sliders.add(
              SliderModel(
                image: r.product.images[i],
                index: i,
              ),
            );
            update();
          }
          update();
          disposeProductDetails();
        },
      );
    } catch (e) {
      disposeProductDetails();
      //@todo: Call the failed toast
    }
  }

  void addToFavorite() {
    if (model.inFavorite == 0) {
      Get.find<FavoriteController>().addFavoriteRequest(
        id: model.id,
      );
    }
    productDetailsRequest(
      id: getProductId(),
    );
  }

  void navigateToAddRate() {
    Get.toNamed(
      Routes.addRate,
    );
  }

  void addToCart() {
    GetxStorage().addProductToCart(
      {
        "id": model.id,
        "quantity": 1,
        "sizeId": model.sizes[productSizeIndex].id,
        "size": model.sizes[productSizeIndex].name,
        "color": model.colors[colorIndex].color.name,
        "colorId": model.colors[colorIndex].color.id,
      },
    );
  }

  @override
  void onInit() {
    productDetailsRequest(
      id: getProductId(),
    );
    super.onInit();
  }
}
