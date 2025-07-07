import 'dart:async';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/service/changeable_icons_service.dart';
import 'package:app_mobile/core/service/image_service.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_icon_size.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../home/presentation/controller/home_controller.dart';
import 'edit_product_dialog.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool isLoading = true;
  late int id;
  late String name;
  late String image;
  late int price;
  late int rate;
  late int rateCount;
  late int favorite;
  late int availableQuantity;
  late String sku;
  late String type;
  late String color;
  late String size;
  late int sellingPrice;
  late int discountRatio;
  late String priceExpiry;

  int commentsCount = 0;
  bool showAllComments = false;
  bool isWholesaler = false;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('product_id') ?? 0;
    name = prefs.getString('product_name') ?? '';
    image = prefs.getString('product_image') ?? '';
    price = prefs.getInt('product_price') ?? 0;
    rate = prefs.getInt('product_rate') ?? 0;
    rateCount = prefs.getInt('product_rate_count') ?? 0;
    favorite = prefs.getInt('product_favorite') ?? 0;
    availableQuantity = prefs.getInt('product_quantity') ?? 0;
    sku = prefs.getString('product_sku') ?? '';
    color = prefs.getString('product_color') ?? '';
    size = prefs.getString('product_size') ?? '';
    type = prefs.getString('product_type') ?? '';
    sellingPrice = prefs.getInt('product_selling_price') ?? 0;
    discountRatio = prefs.getInt('product_discount_Ratio') ?? 0;
    isWholesaler = await Get.find<HomeController>().checkIfWholesale();


    setState(() {
      isLoading = false;
    });
  }

  Future<int> getProductQuantityFromSupabase(int productId) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return 0;

    final response = await supabase
        .from('cart_items')
        .select('quantity')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return (response != null && response['quantity'] != null)
        ? response['quantity'] as int
        : 0;
  }


  Future<void> fetchProductDataFromSupabase() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('products')
        .select(
        'name, image, price, price_expiry, rate, selling_price, price_expiry, available_quantity, sku, type, discount_ratio, color, size')
        .eq('id', id)
        .maybeSingle();

    if (response != null && mounted) {
      priceExpiry = response['price_expiry']?.toString() ?? '';
      DateTime? expiry = response['price_expiry'] != null
          ? DateTime.tryParse(response['price_expiry'])
          : null;

      bool isExpired =
      expiry != null ? DateTime.now().isAfter(expiry) : false;

      setState(() {
        name = response['name'] ?? '';
        image = response['image'] ?? '';
        price = (response['price'] ?? 0).toInt();
        rate = (response['rate'] ?? 0).toInt();
        availableQuantity = (response['available_quantity'] ?? 0).toInt();
        sku = response['sku'] ?? '';
        type = response['type'] ?? '';
        discountRatio = (response['discount_ratio'] ?? 0).toInt();
        color = response['color'] ?? '';
        size = response['size'] ?? '';
        sellingPrice = (response['selling_price'] ?? 0).toInt();

      });

      if (isExpired && response['selling_price'] != 0) {
        await supabase.from('products').update({
          'selling_price': 0,
        }).eq('id', id);
      }

      if (expiry != null && !isExpired) {
        final duration = expiry.difference(DateTime.now());
        _timer?.cancel();
        _timer = Timer(duration, () {
          fetchProductDataFromSupabase();
        });
      }
    }



    final commentsResponse =
    await supabase.from('product_rates').select('id').eq('product_id', id);

    if (mounted) {
      setState(() {
        commentsCount = commentsResponse.length;
      });
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      fetchProductDataFromSupabase();
      //
      // _timer = Timer.periodic(Duration(seconds: 12), (timer) {
      //   fetchProductDataFromSupabase();
      // });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: ManagerColors.primaryColor,
        )),
      );
    }

    return Scaffold(
      backgroundColor: ManagerColors.white,
      appBar: AppBar(
        backgroundColor: ManagerColors.white,
        centerTitle: true,
        title: Text(
          ManagerStrings.productDetails,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s18,
            color: ManagerColors.primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(ManagerIcons.arrowBackIos),
          iconSize: ManagerIconSize.s18,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.offNamed(Routes.cart);
            },
            icon: SvgPicture.asset(ChangeableIconsService.getCart()),
          ),
          FutureBuilder<bool>(
            future: Get.find<HomeController>().checkIfAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.edit, color: ManagerColors.borderSide),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditProductDialog(
                        product: {
                          'id': id,
                          'name': name,
                          'image': image,
                          'price': price,
                          'rate': rate,
                          'rateCount': rateCount,
                          'favorite': favorite,
                          'available_quantity': availableQuantity,
                          'sku': sku,
                          'type': type,
                          'selling_price': sellingPrice,
                          'discount_ratio': discountRatio,
                          'color': color,
                          'size': size,
                          'price_expiry': priceExpiry,
                        },
                        onUpdate: fetchProductDataFromSupabase,
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(ManagerWidth.w16),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageService.networkImage(path: image),
            ),
          ),
          SizedBox(height: ManagerHeight.h16),
          Text(name,
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s24, color: ManagerColors.black)),
          SizedBox(height: ManagerHeight.h10),
          // Row(
          //   children: [
          //     if ((discountRatio) > 0) ...[
          //       Text(
          //         '$price',
          //         style: getRegularTextStyle(
          //           fontSize: ManagerFontSize.s16,
          //           color: ManagerColors.grey,
          //         ).copyWith(decoration: TextDecoration.lineThrough),
          //       ),
          //       SizedBox(width: ManagerWidth.w8),
          //       Text(
          //         '$sellingPrice',
          //         style: getBoldTextStyle(
          //           fontSize: ManagerFontSize.s20,
          //           color: ManagerColors.red,
          //         ),
          //       ),
          //     ] else ...[
          //       Text(
          //         '$price',
          //         style: getBoldTextStyle(
          //           fontSize: ManagerFontSize.s20,
          //           color: ManagerColors.red,
          //         ),
          //       ),
          //     ],
          //     SizedBox(width: ManagerWidth.w4),
          //     SvgPicture.asset(ManagerImages.shekelIcon),
          //   ],
          // ),
          Row(
            children: [
              if (isWholesaler)
                Text(
                  '$discountRatio',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.red,
                  ),
                )
              else if ((sellingPrice) > 0) ...[
                Text(
                  '$price',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.grey,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
                SizedBox(width: ManagerWidth.w8),
                Text(
                  '$sellingPrice',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.red,
                  ),
                ),
              ] else ...[
                Text(
                  '$price',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.red,
                  ),
                ),
              ],
              SizedBox(width: ManagerWidth.w4),
              SvgPicture.asset(ManagerImages.shekelIcon),
            ],
          ),
          SizedBox(height: ManagerHeight.h10),
          Row(
            children: [
              Text('${ManagerStrings.categories} : ',
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.greenAccent)),
              Text(type,
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.primaryColor)),
            ],
          ),
          SizedBox(height: ManagerHeight.h10),
          Row(
            children: [
              Text(' ${ManagerStrings.code} : ',
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.greenAccent)),
              Text(sku,
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s15,
                      color: ManagerColors.primaryColor)),
            ],
          ),
          SizedBox(height: ManagerHeight.h10),
          Row(
            children: [
              Text(' ${ManagerStrings.color}: ',
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.greenAccent)),
              Text('$color',
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s13,
                      color: ManagerColors.primaryColor)),
              SizedBox(width: ManagerWidth.w10,),
              Text(' ${ManagerStrings.size}: ',
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.greenAccent)),
              Text(size,
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s13,
                      color: ManagerColors.primaryColor)),
            ],
          ),
          SizedBox(height: ManagerHeight.h15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('${ManagerStrings.rate} : ',
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.greenAccent)),
                  SvgPicture.asset(ManagerImages.star),
                  SizedBox(width: 4),
                  // Text('$rate', style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor)),
                  FutureBuilder(
                    future: Supabase.instance.client
                        .from('product_rates')
                        .select('rate')
                        .eq('product_id', id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          '...',
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text(
                          ManagerStrings.error,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        );
                      }

                      final list = snapshot.data as List<dynamic>;

                      if (list.isEmpty) {
                        return Text(
                          '0.0',
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        );
                      }

                      double sum = 0.0;
                      for (var item in list) {
                        sum += (item['rate'] as num).toDouble();
                      }
                      double avg = sum / list.length;

                      return Text(
                        avg.toStringAsFixed(1),
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('$commentsCount',
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.primaryColor)),
                  SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      CacheData.productId = id;
                      CacheData.image = image;
                      print(
                          ' Saved productId to CacheData: ${CacheData.productId}');
                      print(
                          ' Saved productId to CacheData: ${CacheData.image}');

                      Get.offNamed(Routes.addRate);
                    },
                    child: Text(
                      ManagerStrings.reviews,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.black),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w12, vertical: ManagerHeight.h4),
                decoration: BoxDecoration(
                  color: ManagerColors.lightGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ManagerRadius.r10),
                ),
                child: Text(
                  "${ManagerStrings.available}: $availableQuantity",
                  style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (availableQuantity <= 0)
                  ? mainButton(
                      onPressed: () {
                        Get.snackbar(ManagerStrings.unavailable,
                            ' ${ManagerStrings.products} ${ManagerStrings.unavailable}');
                      },
                      buttonName: ManagerStrings.unavailable,
                      color: Colors.grey.shade400,
                    )
                  : mainButton(
                      onPressed: () async {
                        final supabase = Supabase.instance.client;
                        final userId = supabase.auth.currentUser?.id;

                        if (userId == null) {
                          Get.snackbar(
                              ManagerStrings.error, ManagerStrings.youMustLog);
                          return;
                        }

                        final existing = await supabase
                            .from('cart_items')
                            .select()
                            .eq('user_id', userId)
                            .eq('product_id', id)
                            .maybeSingle();

                        if (existing != null) {
                          final currentQty = (existing['quantity'] ?? 1) as int;
                          await supabase.from('cart_items').update({
                            'quantity': currentQty + 1,
                          }).eq('id', existing['id']);
                        } else {
                          await supabase.from('cart_items').insert({
                            'user_id': userId,
                            'product_id': id,
                            'quantity': 1,
                            'created_at': DateTime.now().toIso8601String(),
                          });
                        }

                        Get.snackbar(ManagerStrings.success,
                            ManagerStrings.addSuccessfully);
                        fetchProductDataFromSupabase();
                        await addNotification(
                          title: 'السلة',
                          description: 'تمت إضافة منتج إلى سلة التسوق',
                        );

                      },
                      buttonName: ManagerStrings.addToCart,
                    ),
              SizedBox(width: ManagerWidth.w10),
              StatefulBuilder(
                builder: (context, setState) {
                  return FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final prefs = snapshot.data!;
                      List<String> favorites =
                          prefs.getStringList('favorites') ?? [];
                      final productId = id.toString();
                      final isFavorite = favorites.contains(productId);

                      return MaterialButton(
                        height: ManagerHeight.h48,
                        onPressed: () async {
                          final supabase = getIt<SupabaseClient>();
                          final user = supabase.auth.currentUser;

                          if (user == null) {
                            print('المستخدم غير مسجل دخول');
                            return;
                          }

                          if (!isFavorite) {
                            favorites.add(productId);
                            await prefs.setStringList('favorites', favorites);

                            await supabase.from('favorites').insert({
                              'user_id': user.id,
                              'product_id': int.tryParse(productId),
                            });
                          }

                          setState(() {});
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(ManagerRadius.r14),
                          side: const BorderSide(color: ManagerColors.red),
                        ),
                        child: Row(
                          children: [
                            Text(
                              ManagerStrings.favorite,
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s18,
                                color: ManagerColors.red,
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w10),
                            SvgPicture.asset(
                              isFavorite
                                  ? ManagerImages.loved
                                  : ManagerImages.favorite,
                              width: ManagerWidth.w20,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(width: ManagerWidth.w10),
            ],
          ),
          SizedBox(height: ManagerHeight.h15),
          FutureBuilder<bool>(
            future: Get.find<HomeController>().checkIfAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final bool isAdmin = snapshot.data ?? false;

              if (!isAdmin) {
                return const SizedBox();
              }

              return MaterialButton(
                height: ManagerHeight.h48,
                color: ManagerColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManagerRadius.r14),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: ManagerColors.primaryColor, size: 60),
                            const SizedBox(height: 10),
                            const Text(
                              'تأكيد الحذف',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ManagerColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('هل أنت متأكد من حذف هذا المنتج؟'),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: const Text('إلغاء',
                                      style: TextStyle(
                                          color: ManagerColors.primaryColor)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ManagerColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                  child: const Text('تأكيد الحذف',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final supabase = Supabase.instance.client;

                                    try {
                                      await supabase
                                          .from('products')
                                          .delete()
                                          .eq('id', id);
                                      Get.back();
                                      await addNotification(
                                        title: 'حذف المنتج',
                                        description: 'تمت حذف المنتج ${name}',
                                      );

                                      Get.snackbar('تم', 'تم حذف المنتج بنجاح',
                                          backgroundColor: Colors.green);
                                    } catch (e) {
                                      Get.snackbar('خطأ', 'فشل في حذف المنتج',
                                          backgroundColor: Colors.red);
                                    }
                                    Get.find<HomeController>().fetchProductss();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'حذف المنتج',
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: ManagerHeight.h15),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Supabase.instance.client
                .from('product_rates')
                .select('rate, title, comment, created_at')
                .eq('product_id', id)
                .order('rate', ascending: false), // ترتيب حسب النجوم
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('حدث خطأ أثناء تحميل التعليقات');
              }

              final rates = snapshot.data ?? [];

              if (rates.isEmpty) {
                return const Text('لا توجد تقييمات لهذا المنتج حتى الآن.');
              }

              final displayedRates =
                  showAllComments ? rates : rates.take(3).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'التقييمات والتعليقات:',
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s18,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...displayedRates.map((rate) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ManagerColors.greyAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              (rate['rate'] ?? 0),
                              (index) => const Icon(Icons.star,
                                  size: 18, color: ManagerColors.yellow),
                            ),
                          ),
                          if ((rate['title'] ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                rate['title'] ?? '',
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.black,
                                ),
                              ),
                            ),
                          if ((rate['comment'] ?? '').isNotEmpty)
                            Text(
                              rate['comment'] ?? '',
                              style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.grey,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (!showAllComments && rates.length > 3)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() => showAllComments = true);
                        },
                        child: Text(
                          'عرض المزيد',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
