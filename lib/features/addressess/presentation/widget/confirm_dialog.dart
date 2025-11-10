// lib/features/addressess/presentation/widget/confirm_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String message,
  String positive = 'حذف',
  String negative = 'إلغاء',
  Color positiveColor = const Color(0xFFD40A62),
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      content: Text(message,
          textAlign: TextAlign.center, style: getBoldTextStyle(fontSize: 18, color: Colors.black)),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: positiveColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(positive, style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(negative, style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
