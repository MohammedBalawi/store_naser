import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/widgets/main_button.dart';
import '../../presentation/controller/checkout_controller.dart';
import '../widgets/checkout_stepper.dart';
import '../widgets/sheets/rating_sheets.dart';

class CheckoutSuccessView extends StatelessWidget {
  const CheckoutSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  InkWell(
                      onTap: Get.back,
                      child: SvgPicture.asset(isArabic
                          ? ManagerImages.arrows
                          : ManagerImages.arrow_left)),
                  const Spacer(),
                  Text(ManagerStrings.paymentOfTheOrder,
                      style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s20,
                          color: ManagerColors.black)),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            ),



            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CheckoutStepper(step: 3),
            ),
            const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 8,
                    offset: Offset(0, 1),
                  ),
                ],
              borderRadius: BorderRadius.circular(20),
              color: ManagerColors.white
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 400,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration:  BoxDecoration(
                              color:ManagerColors.greens , shape: BoxShape.circle),
                          child: const Icon(Icons.check,
                              size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                         Text(
                           ManagerStrings.supSusses
                          ,
                          textAlign: TextAlign.center,
                          style: getBoldTextStyle(
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: ManagerColors.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${ManagerStrings.orderNumber}: ${c.orderNumber}",
                            style:  getMediumTextStyle(
                                color: Colors.white,
                               fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                    color: ManagerColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:SvgPicture.asset(ManagerImages.notfctaion),),
                        const SizedBox(width: 10),
                         Expanded(
                          child: Text(
                            ManagerStrings.supNotification
                            ,
                            style: getMediumTextStyle(fontSize: 11, color: ManagerColors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            // TODO: نفّذ منطق تفعيل الإشعارات
                          },
                          child: Container(
                            // height: 32,

                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color:ManagerColors.colorpar,
                              borderRadius: BorderRadius.circular(10),),
                            child:  Text(
                              ManagerStrings.activate,
                              style: getBoldTextStyle(
                                  color: ManagerColors.color,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ManagerColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:SvgPicture.asset(ManagerImages.van),),
                        const SizedBox(width: 15),
                         Expanded(
                          child: Text(
                            ManagerStrings.fromToDays
                            ,
                            textAlign:isArabic? TextAlign.right:TextAlign.left,
                            style: getMediumTextStyle(
                                fontSize: 12,color: ManagerColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,  left: 16, right: 16),
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          RatingSheets.showSatisfactionSheet(
                            context,
                            appName: ManagerStrings.eilik,
                            orderNumber: c.orderNumber,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          backgroundColor: ManagerColors.greens,
                          disabledBackgroundColor: ManagerColors.greens,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          ManagerStrings.goToOrderDetailTo,
                          style: getBoldTextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                ),

              ],
            ),
          ),
        )

          ],
        ),
      ),
    );
  }
}
