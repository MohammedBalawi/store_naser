import 'package:app_mobile/features/addressess/presentation/controller/edit_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/main_button.dart';
import '../view/widgets/add_address_field_item.dart';

class EditAddressView extends StatelessWidget {
  const EditAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditAddressController>(
      init: EditAddressController(),
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(title: ManagerStrings.editAddress),
          backgroundColor: ManagerColors.background,
          body: Padding(
            padding: EdgeInsets.all(ManagerWidth.w20),
            child: ListView(
              children: [
                Text(
                  ManagerStrings.editAddress,
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
                        controller.changeCheck(value: value ?? false);
                      },
                    ),
                    SizedBox(width: ManagerWidth.w4),
                    Text(
                      ManagerStrings.useAsDefaultAddress,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h30),
                mainButton(
                  onPressed: () {
                    controller.editAddressRequest();
                  },
                  buttonName: ManagerStrings.editAddress,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
