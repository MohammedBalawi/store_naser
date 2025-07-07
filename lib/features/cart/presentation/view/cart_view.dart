import 'package:app_mobile/features/cart/presentation/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
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
import '../../../../core/service/notifications_service.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final HomeController controller = Get.find<HomeController>();

  Future<int> getQuantityFromSupabase(int productId) async {
    final supabase = Supabase.getIt<SupabaseClient>();
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final response = await supabase
        .from('cart_items')
        .select('quantity')
        .eq('user_id', user.id)
        .eq('product_id', productId)
        .maybeSingle();

    return (response != null && response['quantity'] != null)
        ? response['quantity'] as int
        : 0;
  }

  Future<void> updateCartView() async {
    await controller.fetchCartProducts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.fetchCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: ManagerStrings.cart),
      backgroundColor: ManagerColors.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoadingCart.value) {
          return const Center(child: CircularProgressIndicator(
            color: ManagerColors.primaryColor,
          ));
        }

        if (controller.lastProductss.isEmpty) {
          return Center(
            child: Text(
              ManagerStrings.empty,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.black,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(ManagerHeight.h20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${ManagerStrings.quantity} ",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.grey,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    "${controller.lastProductss.length} ",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.black,
                    ),
                  ),
                  Text(
                    ManagerStrings.productss,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.lastProductss.length,
                  itemBuilder: (context, index) {
                    final item = controller.lastProductss[index];
                    return FutureBuilder<int>(
                      future: getQuantityFromSupabase(item.id),
                      builder: (context, snapshot) {
                        final quantity = snapshot.data ?? 0;

                        return cartItem(
                          model: item,
                          quantity: quantity,
                          onIncrement: () async {
                            final supabase = Supabase.getIt<SupabaseClient>();
                            final user = supabase.auth.currentUser;

                            if (user == null) return;

                            if (quantity < (item.availableQuantity ?? 1)) {
                              await supabase.from('cart_items').update({
                                'quantity': quantity + 1,
                              }).eq('user_id', user.id).eq('product_id', item.id);
                            } else {
                              Get.snackbar(ManagerStrings.warning, ManagerStrings.youHaveReachedTheMaximumAvailableLimit);
                            }

                            await updateCartView();
                          },
                          onDecrement: () async {
                            final supabase = Supabase.getIt<SupabaseClient>();
                            final user = supabase.auth.currentUser;

                            if (user == null) return;

                            if (quantity <= 1) {
                              await supabase
                                  .from('cart_items')
                                  .delete()
                                  .eq('user_id', user.id)
                                  .eq('product_id', item.id);
                            } else {
                              await supabase.from('cart_items').update({
                                'quantity': quantity - 1,
                              }).eq('user_id', user.id).eq('product_id', item.id);
                            }

                            await updateCartView();
                          },
                          onDelete: () async {
                            final supabase = Supabase.getIt<SupabaseClient>();
                            final user = supabase.auth.currentUser;

                            if (user == null) return;

                            await supabase
                                .from('cart_items')
                                .delete()
                                .eq('user_id', user.id)
                                .eq('product_id', item.id);

                            await updateCartView();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomSheet: Obx(() {
        return controller.lastProductss.isEmpty
            ? const SizedBox.shrink()
            : Container(
          color: ManagerColors.background,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ManagerHeight.h16,
                    left: ManagerHeight.h16,
                    right: ManagerHeight.h16,
                    bottom: ManagerHeight.h26,
                  ),
                  child: mainButton(
                    onPressed: () async {
                      final supabase = Supabase.getIt<SupabaseClient>();
                      final userId = supabase.auth.currentUser?.id;

                      if (userId == null) {
                        Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
                        return;
                      }

                      final cartItems = await supabase
                          .from('cart_items')
                          .select()
                          .eq('user_id', userId);

                      if (cartItems.isEmpty) {
                        Get.snackbar(ManagerStrings.warning, ManagerStrings.empty);
                        return;
                      }

                      final productIds = cartItems.map((e) => e['product_id']).toList();
                      final productNames = controller.lastProductss
                          .where((item) => productIds.contains(item.id))
                          .map((e) => e.name ?? '')
                          .toList();

                      final total = controller.lastProductss.fold<double>(0, (sum, item) {
                        final cartItem = cartItems.firstWhere(
                              (e) => e['product_id'] == item.id,
                          orElse: () => {'quantity': 1},
                        );
                        final qty = cartItem['quantity'] ?? 1;
                        return sum + (item.price ?? 0) * qty;
                      });

                      await supabase.from('orders').insert({
                        'user_id': userId,
                        'total': total,
                        'status': 'pending',
                        'product_names': productNames,
                        'created_at': DateTime.now().toIso8601String(),
                      });

                      // Update product quantities in products table
                      for (var item in cartItems) {
                        final productId = item['product_id'];
                        final qty = item['quantity'];

                        final product = await supabase
                            .from('products')
                            .select('available_quantity')
                            .eq('id', productId)
                            .maybeSingle();

                        final currentAvailable = product?['available_quantity'] ?? 0;

                        await supabase.from('products').update({
                          'available_quantity': currentAvailable - qty,
                        }).eq('id', productId);
                      }

                      await supabase.from('cart_items').delete().eq('user_id', userId);

                      Get.snackbar(ManagerStrings.success, ManagerStrings.sendOtpSuccess);
                      controller.fetchCartProducts();
                      await addNotification(
                        title: 'الطلبات',
                        description: 'تمت إضافة منتج إلى الطلبات بنجاح',
                      );

                    },
                    buttonName: ManagerStrings.completeOrder,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManagerRadius.r26),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
