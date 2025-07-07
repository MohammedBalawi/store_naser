import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../constants/constants/constants.dart';
import '../../../../core/locale/locale_controller.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes/routes.dart';
import '../view/widget/out_boarding_item.dart';

class OutBoardingController extends GetxController {
  final Box authBox = Hive.box('authBox');

  List outBoardingItems = [
    OutBoardingItem(
      title: ManagerStrings.outBoardingTitle1,
      subTitle: ManagerStrings.outBoardingSubTitle1,
      image: ManagerImages.outBoardingImage1,
    ),
    OutBoardingItem(
      title: ManagerStrings.outBoardingTitle2,
      subTitle: ManagerStrings.outBoardingSubTitle2,
      image: ManagerImages.outBoardingImage2,
    ),
    OutBoardingItem(
      title: ManagerStrings.outBoardingTitle3,
      subTitle: ManagerStrings.outBoardingSubTitle3,
      image: ManagerImages.outBoardingImage3,
    ),
  ];

  String buttonNextText = ManagerStrings.continueButton;
  static const firstPage = 0;
  static const lastPage = 2;
  static int currentPage = 0;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    LocaleController localeController = LocaleController();
    localeController.changeLanguage(authBox.get('locale', defaultValue: 'ar'));
    pageController = PageController();
  }

  int getCurrentPage() {
    return currentPage;
  }

  void setCurrentIndex(index) {
    currentPage = index;
    setButtonText();
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void skipPage() {
    animateToPage(index: lastPage);
    currentPage = lastPage;
    update();
  }

  void nextPage() {
    if (isNotLastedPage()) {
      animateToPage(index: ++currentPage);
      update();
    }
  }

  Future<void> getStart() async {
    await authBox.put('outBoardingViewed', true);
    final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

    if (isLoggedIn) {
      Get.offAllNamed(Routes.main);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  void previousPage() {
    if (isNotFirstPage()) {
      animateToPage(index: --currentPage);
      update();
    }
  }

  void setButtonText() {
    buttonNextText = currentPage == lastPage
        ? ManagerStrings.startButton
        : ManagerStrings.continueButton;
  }

  Future<void> animateToPage({required int index}) {
    return pageController.animateToPage(
      index,
      duration: const Duration(seconds: Constants.outBoardingDurationTime),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  bool isNotLastedPage() {
    return currentPage < lastPage;
  }

  bool isNotFirstPage() {
    return currentPage > firstPage;
  }

  bool showBackButton() {
    return currentPage > firstPage && currentPage < lastPage;
  }
}
