import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeVerification extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final void Function(String value) onChanged;
  final String? Function(String?)? validator;
  final bool hasError; // جديد: للتحكم بلون الحدود عند الخطأ

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
    hasError ? const Color(0xFFD81B60) : const Color(0xFFE6E6E6);

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
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? const Color(0xFFD81B60) : ManagerColors.primaryColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
