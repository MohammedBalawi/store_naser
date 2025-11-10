import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/widgets/pop_cope_widget.dart';
import 'package:flutter/material.dart';
import '../resources/manager_height.dart';
import 'arrow_back_button.dart';

Widget scaffoldWithImageBackground({
  required Widget child,
  bool isRegisterView = false,
}) {
  return willPopScope(
    child: Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: isRegisterView ? arrowBackButton() : Container(),
      ),
      backgroundColor: ManagerColors.white,
      body: Container(
        margin: EdgeInsetsDirectional.only(
          top: ManagerHeight.h12,
        ),
        child: child ,
      ),
    ),
  );
}
