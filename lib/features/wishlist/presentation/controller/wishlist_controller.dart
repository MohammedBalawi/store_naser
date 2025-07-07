import 'package:get/get.dart';

class WishlistController extends GetxController {
  late int wishlistIndex = 0;
  late int filterWishlistIndex = 0;
  final List<String> wishlist = <String>[
    'الكل',
    'رجالي',
    'نسائي',
  ];
  final List<String> filterWishlist = <String>[
    'القمصان',
    'البناطيل',
    'السترات',
    'البدلات',
    'الأحذية',
  ];

  void updateWishlistIndex(int index) {
    wishlistIndex = index;
    update();
  }

  void updateFilterWishlistIndex(int index) {
    filterWishlistIndex = index;
    update();
  }
}
