// lib/features/account_edit/presentation/widget/field_shell.dart
import 'package:flutter/material.dart';

class FieldShell extends StatelessWidget {
  const FieldShell({super.key, required this.child, this.error});
  final Widget child;
  final bool? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (error ?? false) ? const Color(0xFFD7374A) : const Color(0xFFE9E9EF),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: child,
    );
  }
}
