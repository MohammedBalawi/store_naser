import 'dart:io';

import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/di/dependency_injection.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_icon_size.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_width.dart';
import '../service/image_service.dart';

Widget productItem({
  required ProductModel model,
  bool enableCart = true,
  VoidCallback? onPriceExpired,
}) {
  return FutureBuilder(
    future: _checkAndExpirePrice(model),
    builder: (context, snapshot) {
      return GestureDetector(
        onTap: () async {
          CacheData cache = CacheData();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('product_id', model.id);
          await prefs.setString('product_name', model.name ?? '');
          await prefs.setString('product_image', model.image ?? '');
          await prefs.setInt('product_price', model.price ?? 0);
          await prefs.setInt('product_rate', model.rate ?? 0);
          await prefs.setInt('product_rate_count', model.rateCount ?? 0);
          await prefs.setInt('product_favorite', model.favorite ?? 0);
          await prefs.setInt('product_quantity', model.availableQuantity ?? 0);
          await prefs.setString('product_sku', model.sku ?? '');
          await prefs.setString('product_type', model.type ?? '');
          await prefs.setInt('product_selling_price', model.sellingPrice ?? 0);
          await prefs.setInt('product_discount_Ratio', model.discountRatio ?? 0);
      
          print('✔ تم حفظ بيانات المنتج في SharedPreferences:');
          print('اسم: ${model.name}, الكمية المتاحة: ${model.availableQuantity}');
      
          Get.toNamed(Routes.productDetails);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
          width: ManagerWidth.w167,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ManagerRadius.r10),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x0C000000),
                blurRadius: ManagerRadius.r3,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ManagerHeight.h170,
                child: Stack(
                  children: [
                    Container(
                      height: ManagerHeight.h150,
                      decoration: BoxDecoration(
                        color: ManagerColors.background,
                        image: DecorationImage(
                          image: ImageService.networkImageContainer(
                            path: model.image!,
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(
                          ManagerRadius.r10,
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: ManagerWidth.w4,
                      top: ManagerHeight.h126,
                      child: Container(
                        width: ManagerWidth.w36,
                        height: ManagerHeight.h36,
                        clipBehavior: Clip.antiAlias,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 8,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return IconButton(
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                List<String> favorites =
                                    prefs.getStringList('favorites') ?? [];
                                final productId = model.id.toString();
      
                                final supabase = getIt<SupabaseClient>();
                                final user = supabase.auth.currentUser;
      
                                if (user == null) {
                                  print(' لا يوجد مستخدم مسجل دخول');
                                  return;
                                }
      
                                if (favorites.contains(productId)) {
                                  favorites.remove(productId);
                                  await prefs.setStringList('favorites', favorites);
      
                                  await supabase
                                      .from('favorites')
                                      .delete()
                                      .eq('user_id', user.id)
                                      .eq('product_id', model.id);
                                } else {
                                  favorites.add(productId);
                                  await prefs.setStringList('favorites', favorites);
      
                                  await supabase.from('favorites').insert({
                                    'user_id': user.id,
                                    'product_id': model.id,
                                  });
                                }
      
                                setState(() {});
                              },
                              icon: FutureBuilder<SharedPreferences>(
                                future: SharedPreferences.getInstance(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const SizedBox();
                                  final prefs = snapshot.data!;
                                  List<String> favorites =
                                      prefs.getStringList('favorites') ?? [];
                                  final isFavorite =
                                      favorites.contains(model.id.toString());
      
                                  return SvgPicture.asset(
                                    isFavorite
                                        ? ManagerImages.loved
                                        : ManagerImages.favorite,
                                    width: ManagerWidth.w22,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: ManagerWidth.w16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      textAlign: TextAlign.right,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h2,
                    ),
                    // Row(
                    //   children: [
                    //     if ((model.sellingPrice ?? 0) > 0) ...[
                    //       Text(
                    //         '${model.price}',
                    //         style: getRegularTextStyle(
                    //           fontSize: ManagerFontSize.s12,
                    //           color: ManagerColors.grey,
                    //         ).copyWith(decoration: TextDecoration.lineThrough),
                    //       ),
                    //       SizedBox(width: ManagerWidth.w4),
                    //       Text(
                    //         '${model.sellingPrice}',
                    //         style: getBoldTextStyle(
                    //           fontSize: ManagerFontSize.s14,
                    //           color: ManagerColors.red,
                    //         ),
                    //       ),
                    //     ] else ...[
                    //       Text(
                    //         '${model.price}',
                    //         style: getBoldTextStyle(
                    //           fontSize: ManagerFontSize.s14,
                    //           color: ManagerColors.red,
                    //         ),
                    //       ),
                    //     ],
                    //     SizedBox(width: ManagerWidth.w4),
                    //     SvgPicture.asset(
                    //       ManagerImages.shekelIcon,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: ManagerHeight.h2),
                    Row(
                      children: [
                        if ((model.sellingPrice ?? 0) > 0) ...[
                          Text(
                            '${model.price}',
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s12,
                              color: ManagerColors.grey,
                            ).copyWith(decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(width: ManagerWidth.w4),
                          Text(
                            '${model.sellingPrice}',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: ManagerColors.red,
                            ),
                          ),
                        ] else ...[
                          Text(
                            '${model.price}',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: ManagerColors.red,
                            ),
                          ),
                        ],
                        SizedBox(width: ManagerWidth.w4),
                        SvgPicture.asset(ManagerImages.shekelIcon),
                      ],
                    ),
                    SizedBox(
                      height: ManagerHeight.h2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              ManagerImages.star,
                            ),
                            SizedBox(
                              width: ManagerWidth.w4,
                            ),
                            FutureBuilder(
                              future: Supabase.instance.client
                                  .from('product_rates')
                                  .select('rate')
                                  .eq('product_id', model.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    '0.0',
                                    style: getBoldTextStyle(
                                      fontSize: ManagerFontSize.s10,
                                      color: ManagerColors.primaryColor,
                                    ),
                                  );
                                }

                                final list = snapshot.data as List<dynamic>;

                                if (list.isEmpty) {
                                  return Text(
                                    '0.0',
                                    style: getBoldTextStyle(
                                      fontSize: ManagerFontSize.s10,
                                      color: ManagerColors.primaryColor,
                                    ),
                                  );
                                }

                                // Calculate average
                                double sum = 0.0;
                                for (var item in list) {
                                  sum += (item['rate'] as num).toDouble();
                                }
                                double avg = sum / list.length;

                                return Text(
                                  avg.toStringAsFixed(1), // for example 4.2
                                  style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s10,
                                    color: ManagerColors.primaryColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       '${model.rateCount}',
                        //       style: getBoldTextStyle(
                        //           fontSize: ManagerFontSize.s10,
                        //           color: ManagerColors.primaryColor),
                        //     ),
                        //     SizedBox(
                        //       width: ManagerWidth.w4,
                        //     ),
                        //     Text(
                        //       ManagerStrings.reviews,
                        //       style: getRegularTextStyle(
                        //           fontSize: ManagerFontSize.s10,
                        //           color: ManagerColors.primaryColor),
                        //     )
                        //   ],
                        // ),
                        Row(
                          children: [
                            FutureBuilder(
                              future: Supabase.instance.client
                                  .from('product_rates')
                                  .select('id')
                                  .eq('product_id', model.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('0',
                                      style: getBoldTextStyle(
                                          fontSize: ManagerFontSize.s10,
                                          color: ManagerColors.primaryColor));
                                }

                                final list = snapshot.data as List;
                                return Text(
                                  '${list.length}',
                                  style: getBoldTextStyle(
                                      fontSize: ManagerFontSize.s10,
                                      color: ManagerColors.primaryColor),
                                );
                              },
                            ),
                            SizedBox(
                              width: ManagerWidth.w4,
                            ),
                            Text(
                              ManagerStrings.reviews,
                              style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s10,
                                  color: ManagerColors.primaryColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ManagerHeight.h8,
              ),
              if (enableCart)

                    Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: ManagerWidth.w8,
                ),
                child: Row(
                  children: [
                    mainButton(
                        color: ManagerColors.scaffoldBackgroundColor,
                        minWidth:ManagerWidth.w22,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        onPressed: () {},
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ManagerRadius.r4,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: ManagerIconSize.s12,
                        ),
                        height:ManagerHeight.h30),
                    SizedBox(
                      width: ManagerWidth.w4,
                    ),
                    Expanded(
                      child: mainButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          CacheData cacheData = CacheData();
                          cacheData.setProductId(
                            model.id,
                          );
                          Get.toNamed(
                            Routes.productDetails,
                          );
                        },
                        elevation: 0,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ManagerRadius.r4,
                          ),
                        ),
                        child: Text(
                          ManagerStrings.addToCart,
                          style: getRegularTextStyle(
                            fontSize:ManagerFontSize.s10,
                            color: ManagerColors.white,
                          ),
                        ),
                        height: ManagerHeight.h30,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      );
    }
  );
}
Future<void> _checkAndExpirePrice(ProductModel model) async {
  if (model.priceExpiry == null) return;

  final expiry = DateTime.tryParse(model.priceExpiry!);
  if (expiry == null || DateTime.now().isBefore(expiry)) return;

  final supabase = getIt<SupabaseClient>();
  await supabase.from('products').update({'selling_price': 0}).eq('id', model.id);
}
