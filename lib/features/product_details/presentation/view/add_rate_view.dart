import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/service/image_service.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:app_mobile/features/product_details/domain/di/di.dart';
import 'package:app_mobile/features/product_details/presentation/controller/add_rate_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/libs/rating/rating.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';

class AddRateView extends StatefulWidget {
  const AddRateView({super.key});

  @override
  State<AddRateView> createState() => _AddRateViewState();
}

class _AddRateViewState extends State<AddRateView> {
  late int productId;
  late String productImage;

  @override
  void initState() {
    super.initState();

    productId = CacheData.productId;
    productImage = CacheData.image;

    print(' ProductId: $productId');
    print(' ProductImage: $productImage');

    final controller = Get.find<AddRateController>();
    controller.productId = productId;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddRateController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.white,
          appBar: mainAppBar(
            title: ManagerStrings.addAssessment,
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: ManagerHeight.h10),
              Padding(
                padding: EdgeInsets.only(
                  top: ManagerHeight.h12,
                  left: ManagerHeight.h4,
                  right: ManagerHeight.h4,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(ManagerHeight.h14),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ManagerRadius.r20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        // width: ManagerWidth.w300,
                        // height: ManagerHeight.h150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ManagerRadius.r6),
                          child: ImageService.networkImage(path: productImage),
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(ManagerHeight.h14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ManagerRadius.r6),
                            ),
                            width: ManagerWidth.w50,
                            child: ImageService.networkImage(
                              path: controller.avatar,
                            ),
                          ),
                        ),
                        Container(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ManagerHeight.h10),
                            SizedBox(
                              width: ManagerWidth.w150,
                              child: Text(
                                controller.userName,
                                textAlign: TextAlign.right,
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.black,
                                ),
                              ),
                            ),
                            RatingBar(
                              itemSize: ManagerWidth.w16,
                              ignoreGestures: false,
                              itemPadding: EdgeInsets.all(ManagerHeight.h2),
                              initialRating: controller.rate,
                              minRating: 1,
                              ratingWidget: RatingWidget(
                                full: SvgPicture.asset(
                                  ManagerImages.filledStar,
                                  width: ManagerWidth.w30,
                                ),
                                half: SvgPicture.asset(
                                  ManagerImages.filledStar,
                                ),
                                empty: SvgPicture.asset(
                                  ManagerImages.emptyStar,
                                ),
                              ),
                              onRatingUpdate: controller.changeRate,
                              allowHalfRating: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(ManagerHeight.h14),
                      child: Column(
                        children: [
                          textField(
                            hintText: ManagerStrings.assessmentTitle,
                            controller: controller.title,
                            onChange: (value) {
                              controller.update();
                            },
                          ),
                          SizedBox(height: ManagerHeight.h30),
                          textField(
                            hintText: ManagerStrings.assessmentDescription,
                            controller: controller.comment,
                            maxLines: 4,
                            onChange: (value) {
                              controller.update();
                            },
                          ),
                          SizedBox(height: ManagerHeight.h50),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(ManagerHeight.h10),
                                  child: mainButton(
                                    elevation: 0,
                                    isBold: true,
                                    enabled: controller.checkButtonEnabled(),
                                    isLoading: controller.isLoading,
                                    onPressed: () {
                                      controller.addRate();
                                    },
                                    buttonName: ManagerStrings.addAssessment,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    disposeAddRate();
    super.dispose();
  }
}
