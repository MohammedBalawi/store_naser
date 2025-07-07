import 'dart:io';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_fonts.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/widgets/text_field.dart';
import '../../features/categories/domain/model/category_model.dart';
import '../../features/contact_us/presentation/view/contact_us_view.dart';
import '../../features/home/presentation/controller/home_controller.dart';
import '../service/notifications_service.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final skuController = TextEditingController();
  final availableController = TextEditingController();
  final discountController = TextEditingController();
  final daysController = TextEditingController();
  final List<String> timeUnits = ['ثانية', 'دقيقة', 'ساعة', 'يوم', 'أسبوع', 'شهر'];
  String selectedUnit = 'يوم';

  final picker = ImagePicker();
  XFile? imageFile;

  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final supabase = Get.find<HomeController>().supabase;
    final response = await supabase.from('product_main_category').select();
    setState(() {
      categories = (response as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ManagerStrings.addProduct,
                style: TextStyle(
                  fontSize: ManagerFontSize.s22,
                  fontWeight: FontWeight.w600,
                  fontFamily: ManagerFontFamily.fontFamily,
                  color: ManagerColors.primaryColor,
                  shadows: [
                    Shadow(
                      color: ManagerColors.primaryColor.withOpacity(0.3),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              textField(hintText: ManagerStrings.newProducts, controller: nameController),
              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.price, controller: priceController, textInputType: TextInputType.number),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: textField(
                      hintText: ManagerStrings.sellingPrice,
                      controller: sellingPriceController,
                      textInputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: textField(
                      hintText: 'المدة',
                      controller: daysController,
                      textInputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedUnit,
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value!;
                      });
                    },
                    items: timeUnits.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.quantity, controller: availableController, textInputType: TextInputType.number),
              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.discount, controller: discountController, textInputType: TextInputType.number),
              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.color, controller: colorController),
              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.size, controller: sizeController),
              const SizedBox(height: 12),
              textField(hintText: ManagerStrings.code, controller: skuController),
              const SizedBox(height: 12),
              DropdownButtonFormField<CategoryModel>(
                decoration: InputDecoration(
                  filled: true,

                  fillColor: ManagerColors.pinkBackground,
                  labelText: ManagerStrings.choiceCategories,
                  labelStyle:  getRegularTextStyle(color: ManagerColors.primaryColor,
                      fontSize: ManagerFontSize.s16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: ManagerColors.primaryColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: ManagerColors.primaryColor, width: 2), // لون الحدود عند التركيز
                  ),
                ),
                value: selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      decoration: BoxDecoration(
                        color: ManagerColors.pink.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category_outlined, color: ManagerColors.primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            cat.name,
                            style: getMediumTextStyle(
                              fontSize: ManagerFontSize.s18,

                              color: ManagerColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value);
                },
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageFile != null
                    ? Image.file(
                  File(imageFile!.path),
                  height: ManagerHeight.h140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: ManagerHeight.h140,
                  decoration: BoxDecoration(
                    color: ManagerColors.pinkBackground,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ManagerColors.primaryColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      ManagerStrings.noImageSelected,
                      style:  getRegularTextStyle(
                        color: ManagerColors.primaryColor,
                        fontSize: ManagerFontSize.s16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManagerColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  elevation: 6,
                ),
                icon: const Icon(Icons.image_outlined, color: Colors.white),
                label: Text(ManagerStrings.choiceImage,
                    style:  getRegularTextStyle(
                        color: ManagerColors.white,
                      fontSize: ManagerFontSize.s16,
                    )),
                onPressed: () async {
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => imageFile = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              isUploading
                  ? Column(
                children: [
                  const LinearProgressIndicator(minHeight: 6, color: ManagerColors.primaryColor),
                  const SizedBox(height: 10),
                  Text(ManagerStrings.uploadingImage, style: getRegularTextStyle(
                      color: ManagerColors.primaryColor,
                      fontSize: ManagerFontSize.s16)),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(ManagerStrings.cancel, style: getRegularTextStyle(
                        color: ManagerColors.primaryColor,
                        fontSize: ManagerFontSize.s16)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    icon:  const Icon(Icons.check_circle_outline, color: ManagerColors.white),
                    label: Text(ManagerStrings.addProduct, style:  getRegularTextStyle(
                        color: Colors.white,
                        fontSize: ManagerFontSize.s16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || imageFile == null || selectedCategory == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.requiredFields);
      return;
    }

    try {
      setState(() => isUploading = true);

      final uuid = const Uuid().v4();
      final fileExt = imageFile!.path.split('.').last;
      final filePath = 'products/$uuid.$fileExt';
      final imageBytes = await imageFile!.readAsBytes();

      final supabase = Get.find<HomeController>().supabase;
      DateTime? expiryDate;
      if (daysController.text.isNotEmpty) {
        final value = int.tryParse(daysController.text.trim()) ?? 0;
        switch (selectedUnit) {
          case 'ثانية':
            expiryDate = DateTime.now().add(Duration(seconds: value));
            break;
          case 'دقيقة':
            expiryDate = DateTime.now().add(Duration(minutes: value));
            break;
          case 'ساعة':
            expiryDate = DateTime.now().add(Duration(hours: value));
            break;
          case 'يوم':
            expiryDate = DateTime.now().add(Duration(days: value));
            break;
          case 'أسبوع':
            expiryDate = DateTime.now().add(Duration(days: value * 7));
            break;
          case 'شهر':
            expiryDate = DateTime.now().add(Duration(days: value * 30));
            break;
        }
      }


      await supabase.storage.from('product-images').uploadBinary(filePath, imageBytes);
      final imageUrl = supabase.storage.from('product-images').getPublicUrl(filePath);

      await supabase.from('products').insert({
        'name': nameController.text.trim(),
        'price': double.tryParse(priceController.text.trim()) ?? 0,
        'selling_price': double.tryParse(sellingPriceController.text.trim()) ?? 0,
        'price_expiry': expiryDate?.toIso8601String(),
        'color': colorController.text.trim(),
        'size': sizeController.text.trim(),
        'sku': skuController.text.trim(),
        'image': imageUrl,
        'discount_ratio': discountController.text.trim(),
        'available_quantity': availableController.text.trim(),
        'category_id': selectedCategory!.id,
        'created_at': DateTime.now().toIso8601String(),
        'type': selectedCategory!.name,
      });

      Get.back();
      await addNotification(
        title: 'اضافة منتج ',
        description: 'تمت إضافة منتج بنجاح',
      );

      Get.snackbar(ManagerStrings.success, ManagerStrings.addSuccessfully);
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.failedUpdated);
      print('Add Product Error: $e');
    } finally {
      setState(() => isUploading = false);
      homeController.fetchProductss();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    sellingPriceController.dispose();
    colorController.dispose();
    sizeController.dispose();
    skuController.dispose();
    availableController.dispose();
    discountController.dispose();
    daysController.dispose();
    super.dispose();
  }
}
