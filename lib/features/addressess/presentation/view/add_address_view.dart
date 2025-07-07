import 'package:flutter/material.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/addressess/domain/di/addresses_di.dart';
import 'package:app_mobile/features/addressess/presentation/controller/add_address_controller.dart';
import 'package:app_mobile/features/addressess/presentation/view/widgets/add_address_field_item.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/service/notifications_service.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final supabase = Supabase.instance.client;
  final AddAddressController controller = Get.find<AddAddressController>();

  Future<void> addAddressToSupabase() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
      return;
    }

    try {
      await supabase.from('addresses').insert({
        'user_id': user.id,
        'type': controller.typeController.text,
        'city': controller.cityController.text,
        'state': controller.stateController.text,
        'street': controller.streetController.text,
        'postal_code': controller.postalCodeController.text,
        'is_default': controller.check,
        'created_at': DateTime.now().toIso8601String(),
      });
      Get.back();
      await addNotification(
        title: 'عنوان جديد',
        description: 'تمت إضافة عنوان جديد إلى حسابك',
      );

      Get.snackbar(ManagerStrings.success, ManagerStrings.addressAddedSuccessfully);
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAddressController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.addAddress,
          ),
          backgroundColor: ManagerColors.background,
          body: Padding(
            padding: EdgeInsets.all(
              ManagerWidth.w20,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  ManagerStrings.addAddress,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                ),
                addAddressFieldItem(
                  title: ManagerStrings.addressType,
                  textController: controller.typeController,
                ),
                addAddressFieldItem(
                  title: ManagerStrings.city,
                  textController: controller.cityController,
                ),
                addAddressFieldItem(
                  title: ManagerStrings.state,
                  textController: controller.stateController,
                ),
                addAddressFieldItem(
                  title: ManagerStrings.street,
                  textController: controller.streetController,
                ),
                addAddressFieldItem(
                  title: ManagerStrings.postalCode,
                  textController: controller.postalCodeController,
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: ManagerColors.textColor,
                      value: controller.check,
                      onChanged: (value) {
                        controller.changeCheck(
                          value: value.onNull(),
                        );
                      },
                    ),
                    SizedBox(
                      width: ManagerWidth.w4,
                    ),
                    Text(
                      ManagerStrings.useAsDefaultAddress,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ManagerHeight.h30,
                ),
                mainButton(
                  isLoading: controller.isLoading,
                  onPressed: addAddressToSupabase,
                  buttonName: ManagerStrings.addAddress,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    disposeAddresses();
    super.dispose();
  }
}