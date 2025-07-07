import 'product_category_model.dart';
import 'product_main_category_model.dart';

class ProductModel {
  final int id;
  final String? name;
  final ProductMainCategoryModel? mainCategory;
  final ProductCategoryModel? category;
  late final int? availableQuantity;
  final String? sku;
  final int? rate;
  final int? rateCount;
  final int? price;
  final int? sellingPrice;
  final int? discountRatio;
  final String? image;
  final String? createdAt;
  late final String? size;
  late final String? color;
  final int? favorite;
  final String? type;
  final String? priceExpiry;


  ProductModel( {
    required this.id,
    required this.name,
    this.mainCategory,
    this.category,
    this.availableQuantity,
    this.sku,
    this.rate,
    this.rateCount,
    this.price,
    this.sellingPrice,
    this.discountRatio,
    this.image,
    this.createdAt,
    this.size,
    this.color,
    this.favorite,
    this.type,
    this.priceExpiry,

  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'],
      mainCategory: json['main_category'] != null
          ? ProductMainCategoryModel.fromJson(json['main_category'])
          : null,
      category: json['category'] != null
          ? ProductCategoryModel.fromJson(json['category'])
          : null,
      availableQuantity: json['available_quantity'] ?? 0,
      sku: json['sku'],
      rate: (json['rate'] as num?)?.toInt() ?? 0,
      rateCount: (json['rate_count'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt(),
      sellingPrice: (json['selling_price'] as num?)?.toInt(),
      discountRatio: (json['discount_ratio'] as num?)?.toInt(),
      image: json['image'],
      createdAt: json['created_at'],
      size: json['size'],
      color: json['color'],
      favorite: (json['in_favorite'] as num?)?.toInt(),
      type: json['type'],
      priceExpiry: json['price_expiry'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'main_category_id': mainCategory?.id,
      'category_id': category?.id,
      'available_quantity': availableQuantity,
      'sku': sku,
      'rate': rate,
      'rate_count': rateCount,
      'price': price,
      'selling_price': sellingPrice,
      'discount_ratio': discountRatio,
      'image': image,
      'created_at': createdAt,
      'size': size,
      'color': color,
      'in_favorite':favorite,
      'type':type,
      'price_expiry': priceExpiry,
    };
  }

  factory ProductModel.mock() => ProductModel(
    id: 0,
    name: "منتج تجريبي",
    image: "https://via.placeholder.com/150",
    price: 100,
    sellingPrice: 80,
    discountRatio: 20,
    size: "Medium",
    color: "Red",
    sku: "SKU-123456",
    availableQuantity: 10,
    rate: 4,
    rateCount: 12,
    createdAt: DateTime.now().toIso8601String(),
  );
}
