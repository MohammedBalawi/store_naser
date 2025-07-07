import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/addressess/domain/model/address_model.dart';
import 'package:app_mobile/features/addressess/presentation/controller/addresses_controller.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_width.dart';

Widget addressItem({
  required AddressModel model,
}) {
  return GetBuilder<AddressesController>(builder: (controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ManagerRadius.r12,
        ),
        border: Border.all(
          color: ManagerColors.greyAccent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(
              ManagerHeight.h16,
            ),
            child: Text(
              model.type!,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.grey,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ManagerHeight.h16,
              right: ManagerHeight.h16,
              bottom: ManagerHeight.h8,
            ),
            child: Text(
              "${model.areaId!.name}-${model.govId!.name}",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ManagerHeight.h16,
              right: ManagerHeight.h16,
            ),
            child: Text(
              "${model.govId!.name}-${model.street}",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.grey,
              ),
            ),
          ),
          SizedBox(
            height: ManagerHeight.h20,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: ManagerHeight.h1,
                  color: ManagerColors.greyAccent,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ManagerWidth.w22,
              ),
              GestureDetector(
                onTap: () {
                  controller.navigateToEditAddress(
                    model: model,
                  );
                },
                child: SizedBox(
                  height: ManagerHeight.h46,
                  child: Row(
                    children: [
                      Icon(
                        ManagerIcons.edit,
                        color: ManagerColors.black,
                      ),
                      SizedBox(
                        width: ManagerWidth.w2,
                      ),
                      Text(
                        ManagerStrings.editAddress,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: ManagerWidth.w8,
              ),
              Container(
                height: ManagerHeight.h24,
                width: ManagerWidth.w1,
                color: ManagerColors.greyAccent,
              ),
              SizedBox(
                width: ManagerWidth.w8,
              ),
              GestureDetector(
                onTap: () {
                  controller.deleteAddressRequest(
                    id: model.id!,
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      ManagerIcons.delete,
                      color: ManagerColors.red,
                    ),
                    SizedBox(
                      width: ManagerWidth.w2,
                    ),
                    Text(
                      ManagerStrings.deleteAddress,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  });
}
