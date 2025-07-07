import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_strings.dart';

class DeleteProductButton extends StatelessWidget {
  final int productId;
  const DeleteProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      onPressed: () => _showDeleteDialog(context),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'هل أنت متأكد من حذف المنتج؟',
                textAlign: TextAlign.center,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: ManagerColors.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'إلغاء',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.delete_forever, color: Colors.white),
                    label: const Text(
                      'نعم، احذف',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await _deleteProduct();
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteProduct() async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('products').delete().eq('id', productId);
      Get.snackbar('تم الحذف', 'تم حذف المنتج بنجاح', backgroundColor: Colors.green.shade50);
    } catch (e) {
      Get.snackbar('فشل الحذف', 'حدث خطأ أثناء حذف المنتج', backgroundColor: Colors.red.shade50);
    }
  }
}
