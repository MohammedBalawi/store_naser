import 'package:app_mobile/features/cart/presentation/view/widgets/ShareCartSheet.dart';
import 'package:app_mobile/features/cart/presentation/view/widgets/delete_confirm_dialog.dart' hide showDeleteConfirmDialog;
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/features/cart/presentation/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/home/presentation/controller/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart' as Supabase;
import '../../../checkout/presentation/view/checkout_address_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final HomeController controller = Get.find<HomeController>();

  final Map<int, int> _cartQty = {};
  static const double kBarHeight = 88;
  bool isFav = false;

  Future<void> _fetchAllQuantities() async {
    final supabase = Supabase.getIt<SupabaseClient>();
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final rows = await supabase
        .from('cart_items')
        .select('product_id, quantity')
        .eq('user_id', user.id);

    _cartQty
      ..clear()
      ..addEntries(
        (rows as List)
            .where((e) => e['product_id'] != null)
            .map<MapEntry<int, int>>((e) => MapEntry<int, int>(
          (e['product_id'] as num).toInt(),
          (e['quantity'] as num?)?.toInt() ?? 0,
        )),
      );

    if (mounted) setState(() {});
  }

  Future<void> _refreshCart() async {
    await controller.fetchCartProducts();
    await _fetchAllQuantities();
  }

  @override
  void initState() {
    super.initState();
    controller.fetchCartProducts().then((_) => _fetchAllQuantities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(ManagerStrings.mY_BAG,style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),),
        actions: [
          IconButton(
            onPressed: () {
              final totals = _calcTotals();
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                backgroundColor: Colors.transparent,
                builder: (_) => ShareCartSheet(
                  shareText: '${ManagerStrings.shopping}${totals.$1.toStringAsFixed(2)} ر.س',
                ),
              );
            },
            icon:Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(ManagerImages.shares_icon),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),
      backgroundColor: ManagerColors.scaffoldBackgroundColor,

      body: Obx(() {
        if (controller.isLoadingCart.value) {
          return const Center(child: CircularProgressIndicator(color: ManagerColors.primaryColor));
        }
        if (controller.lastProductss.isEmpty) {
          return Center(
            child: Text(
              ManagerStrings.empty,
              style: getBoldTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.black),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding:EdgeInsets.zero,
                itemCount: controller.lastProductss.length,
                itemBuilder: (context, index) {
                  final item = controller.lastProductss[index];
                  final quantity = _cartQty[item.id] ?? 0;

                  String? discountText;
                  final price = (item.price ?? 0).toDouble();
                  final old = (item.sellingPrice ?? price).toDouble();
                  if (old > price && old > 0) {
                    final p = (((old - price) / old) * 100).round();
                    discountText = '$p%';
                  }

                  return cartItem(
                    context: context,
                    model: item,
                    quantity: quantity,
                    discountText: discountText,
                    showNewRibbon: (item.type ?? '').isNotEmpty,
                    onIncrement: () async {
                      final supabase = Supabase.getIt<SupabaseClient>();
                      final user = supabase.auth.currentUser; if (user == null) return;
                      final currentQty = _cartQty[item.id] ?? 0;
                      if (currentQty <= 0) {
                        await supabase.from('cart_items').insert({'user_id': user.id, 'product_id': item.id, 'quantity': 1});
                      } else {
                        await supabase.from('cart_items').update({'quantity': currentQty + 1})
                            .eq('user_id', user.id).eq('product_id', item.id);
                      }
                      await _refreshCart();
                    },
                    onDecrement: () async {
                      final supabase = Supabase.getIt<SupabaseClient>();
                      final user = supabase.auth.currentUser; if (user == null) return;
                      if (quantity <= 1) {
                        await supabase.from('cart_items').delete()
                            .eq('user_id', user.id).eq('product_id', item.id);
                      } else {
                        await supabase.from('cart_items').update({'quantity': quantity - 1})
                            .eq('user_id', user.id).eq('product_id', item.id);
                      }
                      await _refreshCart();
                    },
                    onConfirmDelete: () async {
                      final supabase = Supabase.getIt<SupabaseClient>();
                      final user = supabase.auth.currentUser; if (user == null) return;
                      final ok = await showDeleteConfirmDialog(context) ?? false;
                      if (!ok) return;
                      await supabase.from('cart_items').delete()
                          .eq('user_id', user.id).eq('product_id', item.id);
                      await _refreshCart();
                    }, isFavorite: isFav,
                    onToggleFavorite: () {
                      setState(() => isFav = !isFav);
                      // أو controller.toggleFavorite(productId);
                    },
                    // showNewRibbon: true,
                    // discountText: '20%', // إن وُجد
                  );
                },
              ),
            ),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        final (total, oldTotal) = _calcTotals();
        final saved = oldTotal - total;

        return SafeArea(
          top: false,
          child: Container(
            height: kBarHeight,
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16, vertical: ManagerHeight.h12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${total.toStringAsFixed(2)} ${ManagerStrings.sAR} (${controller.lastProductss.length} ${ManagerStrings.items})",
                      style: getBoldTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.black),
                    ),
                    if (saved > 0)
                      const SizedBox(height: 4),
                    if (saved > 0)
                      Text(
                        "${ManagerStrings.youSaved}${saved.toStringAsFixed(2)} ${ManagerStrings.sAR}",
                        style: getBoldTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.like),
                      ),
                  ],
                ),
                SizedBox(
                  width: ManagerWidth.w140,
                  child: mainButton(
                    onPressed: () {
                      Get.to(() => const CheckoutAddressView());
                    },
                    buttonName: ManagerStrings.checkout,
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerRadius.r12)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  (double, double) _calcTotals() {
    double total = 0, oldTotal = 0;
    for (var item in controller.lastProductss) {
      final qty = _cartQty[item.id] ?? 0;
      final price = (item.price ?? 0).toDouble();
      final oldPrice = (item.sellingPrice ?? price).toDouble();
      total += price * qty;
      oldTotal += oldPrice * qty;
    }
    return (total, oldTotal);
  }
}
