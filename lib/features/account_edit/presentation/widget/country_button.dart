// widgets/country_button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/change_phone_controller.dart';

class CountryButton extends GetView<ChangePhoneController> {
  CountryButton({super.key});

  final GlobalKey _btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selected.value;

      return Container(
        key: _btnKey,
        decoration: BoxDecoration(
          color: ManagerColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsetsDirectional.only(start: 8, end: 6),
        height: 36,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => controller.openCountryMenu(context, _btnKey),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.expand_more, size: 18, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                sel.dialCode,
                style: getRegularTextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                child: Image.asset(sel.flagAsset),
              ),
            ],
          ),
        ),
      );
    });
  }
}
