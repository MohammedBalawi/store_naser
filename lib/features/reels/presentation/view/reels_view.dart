import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/reels_controller.dart';
import '../modle/reel_card.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final darkBg = const Color(0xFF0E0F12);
    final darkTheme = Theme.of(context).copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      canvasColor: darkBg,
      cardColor: const Color(0xFF151821),
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: Theme.of(context).colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: ManagerColors.color,
        surface: darkBg,
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
    );

    return Theme(
      data: darkTheme,
      child: Scaffold(
        backgroundColor: darkBg,
        body: Obx(() {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.value != null) {
            return Center(
              child: Text(
                controller.error.value!,
                style: getBoldTextStyle(fontSize: 14, color: Colors.white),
              ),
            );
          }
          final items = controller.reels;
          if (items.isEmpty) {
            return  Center(child: Text('لا توجد ريلز حتى الآن',style: getBoldTextStyle(fontSize: 16, color: Colors.black),));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (_, i) => ReelCard(
              reel: items[i],
              onPlay: () => controller.play(items[i]),
              onShare: () => controller.share(items[i]),
              onOrderNow: () => controller.orderNow(items[i]),
            ),
          );
        }),
      ),
    );
  }
}
