import 'package:flutter/material.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/terms/domain/di/terms_di.dart';
import 'package:app_mobile/features/terms/domain/model/terms_data_model.dart';
import 'package:app_mobile/features/terms/domain/usecase/accept_terms_usecase.dart';
import 'package:app_mobile/features/terms/domain/usecase/terms_usecase.dart';
import 'package:get/get.dart';

import '../../../../constants/di/dependency_injection.dart';

class TermsController extends GetxController {
  List<TermsDataModel> terms = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = true;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  bool isAccepted = true;

  void navigateToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(
        seconds: 1,
      ),
      curve: Curves.easeInOut,
    );
  }

  void accept() async {
    initAcceptTermsRequest();
    changeIsLoading(
      value: true,
    );
    final AcceptTermsUseCase useCase = instance<AcceptTermsUseCase>();
    (await useCase.execute()).fold(
      (l) {
        changeIsLoading(
          value: false,
        );
        disposeAcceptTermsRequest();
        //@todo: Call the failed toast
      },
      (r) async {
        changeIsLoading(
          value: false,
        );
        disposeAcceptTermsRequest();
        Get.back();
        //@todo: Call the success toast
      },
    );
  }

  void termsRequest() async {
    changeIsLoading(
      value: true,
    );
    final TermsUseCase useCase = instance<TermsUseCase>();
    (await useCase.execute()).fold(
      (l) {
        changeIsLoading(
          value: false,
        );
        //@todo: Call the failed toast
      },
      (r) async {
        changeIsLoading(
          value: false,
        );
        terms = r.data;
        update();
      },
    );
  }

  bool isInLast() {
    try {
      return (scrollController.position.maxScrollExtent.onNull() ==
              scrollController.position.pixels.onNull()) ||
          (scrollController.position.maxScrollExtent.onNull() - 140 <=
              scrollController.position.pixels.onNull());
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    initTermsRequest();
    scrollController.addListener(
      () {
        update();
      },
    );
    termsRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeTermsRequest();
    super.dispose();
  }
}
