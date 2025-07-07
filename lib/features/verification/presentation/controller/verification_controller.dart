
import 'package:app_mobile/core/validator/validator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  late TextEditingController firstCodeTextController;
  late TextEditingController secondCodeTextController;
  late TextEditingController thirdCodeTextController;
  late TextEditingController fourthCodeTextController;
  late TextEditingController fifthCodeTextController;
  late TextEditingController sixthCodeTextController;

  FieldValidator validator = FieldValidator();
  var formKey = GlobalKey<FormState>();

  late FocusNode firstFocusNode;
  late FocusNode secondFocusNode;
  late FocusNode thirdFocusNode;
  late FocusNode fourthFocusNode;
  late FocusNode fifthFocusNode;
  late FocusNode sixthFocusNode;





  otp() {
    return "${firstCodeTextController.text}${secondCodeTextController.text}${thirdCodeTextController.text}${fourthCodeTextController.text}${fifthCodeTextController.text}${sixthCodeTextController.text}";
  }

  @override
  void onInit() {
    super.onInit();
    firstCodeTextController = TextEditingController();
    secondCodeTextController = TextEditingController();
    thirdCodeTextController = TextEditingController();
    fourthCodeTextController = TextEditingController();
    fifthCodeTextController = TextEditingController();
    sixthCodeTextController = TextEditingController();
    firstFocusNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fourthFocusNode = FocusNode();
    fifthFocusNode = FocusNode();
    sixthFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    firstCodeTextController.dispose();
    secondCodeTextController.dispose();
    thirdCodeTextController.dispose();
    fourthCodeTextController.dispose();
    fifthCodeTextController.dispose();
    sixthFocusNode.dispose();

    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    fifthFocusNode.dispose();
    sixthFocusNode.dispose();
    formKey.currentState!.dispose();
  }
}
