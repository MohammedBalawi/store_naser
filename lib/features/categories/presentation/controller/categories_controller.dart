import 'package:app_mobile/core/model/product_category_model.dart';
import 'package:app_mobile/core/model/product_main_category_model.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/features/categories/domain/di/categories_di.dart';
import 'package:app_mobile/features/categories/domain/model/category_model.dart';
import 'package:app_mobile/features/categories/domain/model/main_category_model.dart';
import 'package:app_mobile/features/categories/domain/usecase/categories_usecase.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/routes/routes.dart';

class CategoriesController extends GetxController {
  int selectedMainCategory = 0;
  int selectedCategory = 0;

  List<MainCategoryModel> mainCategories = [
  //   MainCategoryModel(
  //     id: 1, title: "الكل", categories: [],
  //       // categories: [
  //       //
  //       //   CategoryModel(
  //       //     id: 2,
  //       //     title: "القمصان",
  //       //     image: "",
  //       //     products: [],
  //       //   ),
  //       //   CategoryModel(
  //       //     id: 3,
  //       //     title: "القمصان",
  //       //     image: "",
  //       //       products: [],
  //       //   ),
  //       //   CategoryModel(
  //       //     id: 4,
  //       //     title: "القمصان",
  //       //     image: "",
  //       //       products: [],
  //       //   ),
  //       //   CategoryModel(
  //       //     id: 5,
  //       //     title: "القمصان",
  //       //     image: "",
  //       //       products: [],
  //       //   ),
  //       // ],
  //       ),
  //   MainCategoryModel(
  //     id: 2,
  //     title: "رجالي",
  //     categories: [
  //       CategoryModel(
  //         id: 1,
  //         title: "القمصان",
  //         image: "",
  //         products: [
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //         ],
  //       ),
  //       CategoryModel(id: 2, title: "البناطيل", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg1.png?alt=media&token=87ffba2b-1d8e-48cb-9aa9-b55ce1e738bf",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg1.png?alt=media&token=87ffba2b-1d8e-48cb-9aa9-b55ce1e738bf",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg1.png?alt=media&token=87ffba2b-1d8e-48cb-9aa9-b55ce1e738bf",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg1.png?alt=media&token=87ffba2b-1d8e-48cb-9aa9-b55ce1e738bf",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg1.png?alt=media&token=87ffba2b-1d8e-48cb-9aa9-b55ce1e738bf",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //       CategoryModel(id: 3, title: "السترات", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //       CategoryModel(
  //         id: 4,
  //         title: "البدلات",
  //         image: "",
  //         products: [
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_sales%2Fimg2.png?alt=media&token=a16a1daf-b0e8-4e7c-8b4a-e1842a3750b6",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //             "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_sales%2Fimg2.png?alt=media&token=a16a1daf-b0e8-4e7c-8b4a-e1842a3750b6",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //             "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_sales%2Fimg2.png?alt=media&token=a16a1daf-b0e8-4e7c-8b4a-e1842a3750b6",
  //             createdAt: "2022/22/22",
  //           ),
  //         ],
  //       ),
  //       CategoryModel(id: 5, title: "الأحذبة", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //     ],
  //   ),
  //   MainCategoryModel(
  //     id: 3,
  //     title: "نسائي",
  //     categories: [
  //       CategoryModel(
  //         id: 1,
  //         title: "القمصان",
  //         image: "",
  //         products: [
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  // favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //           ProductModel(
  //             id: 1,
  //             name: "قميص رجالي",
  //             mainCategory: ProductMainCategoryModel(
  //               id: 1,
  //               name: "رجالي",
  //               // icon: "",
  //             ),
  //             category: ProductCategoryModel(
  //               id: 1,
  //               name: "قمصان",
  //               // icon: "",
  //             ),
  //             favorite: 0,
  //             availableQuantity: 5,
  //             sku: "sku",
  //             rate: 4,
  //             rateCount: 9,
  //             price: 100,
  //             sellingPrice: 100,
  //             discountRatio: 0,
  //             image:
  //                 "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //             createdAt: "2022/22/22",
  //           ),
  //         ],
  //       ),
  //       CategoryModel(id: 2, title: "البناطيل", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //       CategoryModel(id: 3, title: "السترات", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //       CategoryModel(id: 4, title: "البدلات", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  //           favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //               "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best_assessments%2Fimg1.png?alt=media&token=fea7aca3-9649-4679-8cb1-f407f232759d",
  //           createdAt: "2022/22/22",
  //         ),
  //       ]),
  //       CategoryModel(id: 5, title: "الأحذبة", image: "", products: [
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  // favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //         ProductModel(
  //           id: 1,
  //           name: "قميص رجالي",
  //           mainCategory: ProductMainCategoryModel(
  //             id: 1,
  //             name: "رجالي",
  //             // icon: "",
  //           ),
  //           category: ProductCategoryModel(
  //             id: 1,
  //             name: "قمصان",
  //             // icon: "",
  //           ),
  //             favorite: 0,
  //           availableQuantity: 5,
  //           sku: "sku",
  //           rate: 4,
  //           rateCount: 9,
  //           price: 100,
  //           sellingPrice: 100,
  //           discountRatio: 0,
  //           image:
  //           "https://firebasestorage.googleapis.com/v0/b/bubble-images.appspot.com/o/best%2Fimg2.png?alt=media&token=0885f019-b35e-46f3-a34f-3fa566425146",
  //           createdAt: "2022/22/22",
  //         ),
  //       ],),
  //     ],
  //   ),
  ];

  bool isLoading = true;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void updateMainCategoryIndex({
    required int index,
  }) {
    selectedMainCategory = index;
    selectedCategory = 0;
    update();
  }

  void updateCategoryIndex({
    required int index,
  }) {
    selectedCategory = index;
    update();
  }

  void categoriesRequest() async {
    changeIsLoading(
      value: true,
    );
    final CategoriesUseCase useCase = instance<CategoriesUseCase>();
    (await useCase.execute()).fold(
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
        mainCategories = r.data;
        update();
      },
    );
  }

  void navigateToProducts({
    required String id,
    required String name,
  }) {
    CacheData cacheData = CacheData();
    cacheData.getCategoryId(

    );
    cacheData.getCategoryName(

    );
    Get.toNamed(
      Routes.categoryProducts,
    );
  }

  @override
  void onInit() {
    initCategoriesRequest();
    categoriesRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeCategoriesRequest();
    super.dispose();
  }
}
