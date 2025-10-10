
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/model/product_model.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/home_app_bar.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/product_item.dart';
import '../../../home/presentation/controller/home_controller.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  List<ProductModel> favoriteProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    super.didChangeDependencies();
    loadFavoritesFromSupabase();
  }

  Future<void> loadFavoritesFromSupabase() async {
    setState(() => isLoading = true);
    final supabase = getIt<SupabaseClient>();
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final response = await supabase
        .from('favorites')
        .select('product_id')
        .eq('user_id', user.id);

    final List<int> productIds = (response as List)
        .map((e) => e['product_id'] as int)
        .toList();

    var allProducts = Get.find<HomeController>().lastProducts;

    if (allProducts.isEmpty) {
      await Get.find<HomeController>().fetchProducts();
      allProducts = Get.find<HomeController>().lastProducts;
    }

    favoriteProducts = allProducts
        .where((p) => productIds.contains(p.id))
        .toList();

    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(ManagerImages.arrows)),
            Text('المفضلة',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(width: 30,),
          ],
        ),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),
      backgroundColor: ManagerColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: ManagerColors.primaryColor,))
          : favoriteProducts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ManagerImages.noFavorite,
            ),
             SizedBox(
              height: ManagerHeight.h16,
            ),
             Text(
              ManagerStrings.emptySavedItems,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s22,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ManagerHeight.h14,
            ),
             Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
              ),
              child: Text(
                ManagerStrings.pressFavoriteItemToAdd,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: ManagerColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
             SizedBox(
              height: ManagerHeight.h24,
            ),
            mainButton(
              onPressed: () {
                loadFavoritesFromSupabase();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w8,
                ),
                child: Text(
                  ManagerStrings.update,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.white,
                  ),
                ),
              ),
              radius: ManagerRadius.r24,
            ),
             SizedBox(
              height: ManagerHeight.h60,
            ),
          ],
        ),
      )
          : RefreshIndicator(
        backgroundColor: Colors.transparent,
        elevation: 0,
        color: ManagerColors.primaryColor,
        onRefresh:loadFavoritesFromSupabase ,
        child: Padding(
          padding: EdgeInsets.all(ManagerHeight.h8),
          child: GridView.builder(
            itemCount: favoriteProducts.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              return productItem(
                model: favoriteProducts[index],
              );
            },
          ),
        ),
      ),
    );
  }

}
