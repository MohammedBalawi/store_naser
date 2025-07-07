import 'package:flutter/material.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/terms/domain/di/terms_di.dart';
import 'package:app_mobile/features/terms/presentation/controller/terms_controller.dart';
import 'package:app_mobile/features/terms/presentation/view/widgets/term_item.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';

class TermsView extends StatefulWidget {
  const TermsView({super.key});

  @override
  State<TermsView> createState() => _TermsViewState();
}

class _TermsViewState extends State<TermsView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.privacyPolicy,
          ),
          backgroundColor: ManagerColors.background,
          body: Padding(
            padding: EdgeInsets.all(
              ManagerHeight.h16,
            ),
            child: ListView(
              controller: controller.scrollController,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < controller.terms.length; i++)
                  termItem(
                    title: controller.terms[i].title,
                    body: controller.terms[i].body,
                  ),
                SizedBox(
                  height: ManagerHeight.h40,
                ),
              ],
            ),
          ),
          bottomSheet: Container(
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
                    child: controller.isInLast()
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ManagerHeight.h40,
                            ),
                            child: mainButton(
                              onPressed: () {
                                controller.accept();
                              },
                              buttonName: ManagerStrings.acceptAndContinue,
                              color: ManagerColors.blueAccent,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ManagerRadius.r26,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ManagerHeight.h40,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                controller.navigateToBottom();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    ManagerRadius.r12,
                                  ),
                                  border: Border.all(
                                    color: ManagerColors.black,
                                  ),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                      left: ManagerHeight.h10,
                                      right: ManagerHeight.h10,
                                      top: ManagerHeight.h6,
                                      bottom: ManagerHeight.h6,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ManagerStrings.navigateToBottom,
                                          style: getRegularTextStyle(
                                            fontSize: ManagerFontSize.s16,
                                            color: ManagerColors.black,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                  ),
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
    disposeTerms();
    super.dispose();
  }
}
