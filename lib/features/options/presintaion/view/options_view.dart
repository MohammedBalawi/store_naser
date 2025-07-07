import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/options/presintaion/controller/options_controller.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/routes.dart';

class OptionsView extends StatefulWidget {
  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            ManagerStrings.myOptions,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: ManagerColors.white,
        body: GetBuilder<OptionsController>(builder: (controller) {
          return ListView(
            children: [
              const Divider(color: ManagerColors.greyLight, thickness: 1.0),
              _buildColorOptions(controller),
              SizedBox(height: ManagerHeight.h12),
              const Divider(color: ManagerColors.greyLight, thickness: 1.0),
              SizedBox(height: ManagerHeight.h12),
              _buildSizeOptions(controller),
              SizedBox(height: ManagerHeight.h12),
              const Divider(color: ManagerColors.greyLight, thickness: 1.0),
              SizedBox(height: ManagerHeight.h12),
              _buildShoeSizeOptions(controller),
              SizedBox(height: ManagerHeight.h60),
              _buildNextButton(),
              SizedBox(height: ManagerHeight.h20),
            ],
          );
        }));
  }

  Widget _buildColorOptions(OptionsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ManagerStrings.colorOption,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          SizedBox(
              height: ManagerHeight.h50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.colorOption.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => controller.updateColorIndex(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: ManagerHeight.h2,
                          horizontal: ManagerWidth.w4),
                      width: ManagerWidth.w60,
                      height: ManagerHeight.h40,
                      decoration: controller.selectedColorIndex == index
                          ? ShapeDecoration(
                              color: controller.colorOption[index],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            )
                          : BoxDecoration(
                              color: controller.colorOption[index],
                              borderRadius:
                                  BorderRadius.circular(ManagerRadius.r8),
                            ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildSizeOptions(OptionsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ManagerStrings.size,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          Container(
              height: ManagerHeight.h34,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.size.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => controller.updateSizeIndex(index),
                    child: Container(
                      width: ManagerWidth.w40,
                      height: ManagerHeight.h34,
                      decoration: BoxDecoration(
                        color: controller.selectedSizeIndex == index
                            ? ManagerColors.blue
                            : ManagerColors.white,
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                        border: Border.all(
                          color: ManagerColors.grey,
                          width: 1.0,
                        ),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: ManagerHeight.h10),
                      child: Center(
                        child: Text(
                          controller.size[index],
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: controller.selectedSizeIndex == index
                                ? ManagerColors.white
                                : ManagerColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildShoeSizeOptions(OptionsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ManagerStrings.sizeShoes,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          Container(
              height: ManagerHeight.h34,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.sizeShoes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => controller.updateShoeSizeIndex(index),
                    child: Container(
                      width: ManagerWidth.w40,
                      height: ManagerHeight.h34,
                      decoration: BoxDecoration(
                        color: controller.selectedShoeSizeIndex == index
                            ? ManagerColors.blue
                            : ManagerColors.white,
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                        border: Border.all(
                          color: ManagerColors.grey,
                          width: 1.0,
                        ),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: ManagerHeight.h10),
                      child: Center(
                        child: Text(
                          controller.sizeShoes[index],
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: controller.selectedShoeSizeIndex == index
                                ? ManagerColors.white
                                : ManagerColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
      child: mainButton(
        height: ManagerHeight.h48,
        onPressed: () {
          Get.offNamed(Routes.welcome);
        },
        buttonName: ManagerStrings.next,
        minWidth: double.infinity,
      ),
    );
  }
}
