import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/pop_cope_widget.dart';
import 'package:app_mobile/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_width.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return willPopScope(
      child: GetBuilder<WishlistController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: ManagerColors.white,
            extendBody: true,
            appBar: AppBar(
              centerTitle: true,
              shadowColor: ManagerColors.grey,
              elevation: 0.5,
              backgroundColor: ManagerColors.white,
              title: Text(
                ManagerStrings.wishlist,
                style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.primaryColor),
              ),
            ),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w16, vertical: ManagerHeight.h8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تصفح التصنيفات حسب الفئات',
                        textAlign: TextAlign.right,
                        style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.grey),
                      ),
                      SizedBox(
                        height: ManagerHeight.h16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...List.generate(
                            controller.wishlist.length,
                            (index) => GestureDetector(
                              onTap: () {
                                controller.updateWishlistIndex(index);
                              },
                              child: Container(
                                width: ManagerWidth.w100,
                                height: ManagerHeight.h30,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: controller.wishlistIndex == index
                                      ? ManagerColors.primaryColor
                                      : ManagerColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ManagerRadius.r30),
                                  ),
                                ),
                                child: Text(
                                  controller.wishlist[index],
                                  style: controller.wishlistIndex == index
                                      ? getBoldTextStyle(
                                          fontSize: ManagerFontSize.s14,
                                          color: ManagerColors.white,
                                        )
                                      : getRegularTextStyle(
                                          fontSize: ManagerFontSize.s14,
                                          color: ManagerColors.primaryColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ManagerHeight.h16,
                      ),
                      Container(
                        height: ManagerHeight.h40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: ManagerOpacity.op0_7),
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ...List.generate(
                              controller.filterWishlist.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  controller.updateFilterWishlistIndex(index);
                                },
                                child: Container(
                                  width: ManagerWidth.w60,
                                  height: ManagerHeight.h30,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color:
                                        controller.filterWishlistIndex == index
                                            ? ManagerColors.primaryColor
                                            : ManagerColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ManagerRadius.r8),
                                    ),
                                  ),
                                  child: Text(
                                    controller.filterWishlist[index],
                                    style: controller.filterWishlistIndex ==
                                            index
                                        ? getBoldTextStyle(
                                            fontSize: ManagerFontSize.s14,
                                            color: ManagerColors.white,
                                          )
                                        : getRegularTextStyle(
                                            fontSize: ManagerFontSize.s14,
                                            color: ManagerColors.primaryColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: ManagerHeight.h8),
                  decoration: ShapeDecoration(
                    color: ManagerColors.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ManagerRadius.r10),
                        topRight: Radius.circular(ManagerRadius.r10),
                      ),
                    ),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: ManagerHeight.h10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container();
                      //@todo: refactor this
                      // return productItem(
                      //     image:
                      //         'https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_1000,c_scale,q_auto/cnnarabic/2020/09/27/images/166028.jpg',
                      //     title: 'فستان نسائي',
                      //     price: 200,
                      //     reviews: 86,
                      //     rating: 4.6,
                      //     addToCart: () {});
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
