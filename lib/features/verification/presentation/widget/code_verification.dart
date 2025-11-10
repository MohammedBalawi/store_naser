import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeVerification extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final void Function(String value) onChanged;
  final String? Function(String?)? validator;
  final bool hasError;


  const CodeVerification({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.previousFocusNode,
    required this.onChanged,
    required this.validator,
    this.hasError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
    hasError ? ManagerColors.like : ManagerColors.gray_divedr;

    return SizedBox(
      width: 62,
      height: 62,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: ManagerColors.primaryColor,
        style:  getMediumTextStyle(fontSize: 16, color: Colors.black),
        inputFormatters:  [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          onChanged(value);
          if (value.isEmpty && previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: hasError ? ManagerColors.like : ManagerColors.primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
