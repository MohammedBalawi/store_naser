import 'package:app_mobile/features/product_details/domain/model/product_rate_model.dart';
import '../../features/addressess/domain/model/address_area_id_model.dart';
import '../../features/addressess/domain/model/address_gov_id_model.dart';
import '../../features/addressess/domain/model/address_model.dart';

/// A class defined for cache data that's used and when close app deleted
class CacheData {
  static int productId = 0;
  static String productName = "";
  static double price = 0;
  static double sellingPrice = 0;
  static String color = "";
  static String size = "";
  static String sku = "";
  static int quantity = 0;
  static String image = "";
  static String categoryId = "";
  static String categoryName = "";

  static String email = "";
  static String username = "";
  static String phone = "";
  static String orderId = "";




  static AddressModel addressModel = AddressModel(
    isDefault: true,
    id: 0,
    type: '',
    street: '',
    postalCode: '',
    lat: '',
    lang: '',
    mobile: '',
    areaId: AddressAreaIdModel(id: 0, name: ""),
    govId: AddressGovIdModel(id: 0, name: ""),
  );

  static ProductRateModel productRateModel = ProductRateModel(
    id: 0,
    rate: 0,
    title: "",
    comment: "",
    image: "",
    createdAt: "",
    userName: "",
    userAvatar: "",
    userId: 0,
  );

  void setProductData({
    required int id,
    required String name,
    required double productPrice,
    required double productSellingPrice,
    required String productColor,
    required String productSize,
    required String productSku,
    required int productQuantity,
    required String imageUrl,
    required String catId,
    required String catName,
  }) {
    productId = id;
    productName = name;
    price = productPrice;
    sellingPrice = productSellingPrice;
    color = productColor;
    size = productSize;
    sku = productSku;
    quantity = productQuantity;
    image = imageUrl;
    categoryId = catId;
    categoryName = catName;
  }

  void setProductId(int value) {
    productId = value;
  }
  int getProductId() => productId;
  String getProductName() => productName;
  double getPrice() => price;
  double getSellingPrice() => sellingPrice;
  String getColor() => color;
  String getSize() => size;
  String getSku() => sku;
  int getQuantity() => quantity;
  String getImage() => image;
  String getCategoryId() => categoryId;
  String getCategoryName() => categoryName;

  void setOrderId(String value) => orderId = value;
  String getOrderId() => orderId;

  void setEmail(String value) => email = value;
  String getEmail() => email;

  void setUsername(String value) => username = value;
  String getUsername() => username;

  void setPhone(String value) => phone = value;
  String getPhone() => phone;


  void setAddressModel({required AddressModel model}) {
    addressModel = model;
  }

  AddressModel getAddressModel() => addressModel;

  void setProductRate({required ProductRateModel model}) {
    productRateModel = model;
  }

  ProductRateModel getProductRate() => productRateModel;
}


