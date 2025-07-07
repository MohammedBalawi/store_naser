import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: mainAppBar(title: "سجل الطلبات"),
      backgroundColor: ManagerColors.scaffoldBackgroundColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase
            .from('orders')
            .select()
            .eq('user_id', user?.id ?? '')
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد طلبات حتى الآن",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.grey,
                ),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(ManagerHeight.h16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final date = DateTime.tryParse(order['created_at'] ?? '')?.toLocal();
              final productNames = List<String>.from(order['product_names'] ?? []);
              final total = order['total'] ?? 0;

              return Container(
                margin: EdgeInsets.only(bottom: ManagerHeight.h12),
                padding: EdgeInsets.all(ManagerWidth.w12),
                decoration: BoxDecoration(
                  color: ManagerColors.white,
                  borderRadius: BorderRadius.circular(ManagerRadius.r12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "التاريخ:",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.grey,
                          ),
                        ),
                        Text(
                          date?.toString().substring(0, 16) ?? 'غير معروف',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ManagerHeight.h10),
                    Text(
                      "المنتجات:",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h4),
                    Text(
                      productNames.join(', '),
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الإجمالي:",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.grey,
                          ),
                        ),
                        Text(
                          "₪ $total",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
