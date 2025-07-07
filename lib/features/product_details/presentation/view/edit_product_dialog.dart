import 'dart:io';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/features/product_details/domain/model/product_details_data_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../categories/domain/model/category_model.dart';
import '../../../home/presentation/controller/home_controller.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final Future<void> Function() onUpdate;

  EditProductDialog({super.key, required this.product, required this.onUpdate});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final rateController = TextEditingController();
  final rateCountController = TextEditingController();
  final favoriteController = TextEditingController();
  final availableController = TextEditingController();
  final skuController = TextEditingController();
  final discountRatioController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final durationController = TextEditingController();


  String selectedUnit = 'ثانية';
  DateTime? currentExpiry;
  final picker = ImagePicker();
  XFile? imageFile;
  String? oldImageUrl;
  String? expiryDateText;


  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    nameController.text = product['name'] ?? '';
    priceController.text = product['price'].toString();
    sellingPriceController.text = product['selling_price'].toString();
    rateController.text = product['rate'].toString();
    rateCountController.text = product['rateCount'].toString();
    favoriteController.text = product['favorite'].toString();
    availableController.text = product['available_quantity'].toString();
    skuController.text = product['sku'] ?? '';
    discountRatioController.text = product['discount_ratio'].toString();
    colorController.text = product['color'] ?? '';
    sizeController.text = product['size'] ?? '';
    oldImageUrl = product['image'];
    if (product['price_expiry'] != null) {
      try {
        final expiry = product['price_expiry'] is String
            ? DateTime.parse(product['price_expiry'])
            : product['price_expiry'] as DateTime;

        expiryDateText = DateFormat('yyyy-MM-dd HH:mm').format(expiry);

      } catch (e) {
        expiryDateText = ManagerStrings.notSpecified;


      }
    } else {
      expiryDateText = ManagerStrings.notSpecified;

    }





    _loadCategories(product['type']);
  }

  Future<void> _loadCategories(String? currentType) async {
    final supabase = Get.find<HomeController>().supabase;
    final response = await supabase.from('product_main_category').select();
    categories = (response as List).map((e) => CategoryModel.fromJson(e)).toList();
    setState(() {
      selectedCategory = categories.firstWhereOrNull((cat) => cat.name == currentType);
    });
  }

  Future<void> _updateProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.requiredFields);
      await addNotification(
        title: 'تحديث المنتج',
        description: 'تم تحديث المنتج  بنجاح ${nameController}   ',
      );

      return;
    }

    setState(() => isUploading = true);

    String? newImageUrl = oldImageUrl;
    final supabase = Get.find<HomeController>().supabase;

    if (imageFile != null) {
      final fileExt = imageFile!.path.split('.').last;
      final filePath = 'products/${widget.product['id']}.$fileExt';
      final imageBytes = await imageFile!.readAsBytes();
      await supabase.storage.from('product-images').uploadBinary(filePath, imageBytes, fileOptions: const FileOptions(upsert: true));
      newImageUrl = supabase.storage.from('product-images').getPublicUrl(filePath);
    }

    String newExpiryDate;
    final durationValue = int.tryParse(sellingPriceController.text.trim()) ?? 0;

    if (durationValue > 0) {
      Duration duration;
      switch (selectedUnit) {
        case 'ثانية':
          duration = Duration(seconds: durationValue);
          break;
        case 'دقيقة':
          duration = Duration(minutes: durationValue);
          break;
        case 'ساعة':
          duration = Duration(hours: durationValue);
          break;
        case 'يوم':
          duration = Duration(days: durationValue);
          break;
        case 'أسبوع':
          duration = Duration(days: 7 * durationValue);
          break;
        case 'شهر':
          duration = Duration(days: 30 * durationValue);
          break;
        default:
          duration = const Duration();
      }
      final expiryTime = DateTime.now().add(duration);
      newExpiryDate = expiryTime.toIso8601String();
    } else {
      newExpiryDate = widget.product['price_expiry'] ?? '';
    }

    final updates = {
      'name': nameController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0,
      'selling_price': double.tryParse(sellingPriceController.text.trim()) ?? 0.0,
      'available_quantity': int.tryParse(availableController.text.trim()) ?? 0,
      'sku': skuController.text.trim(),
      'discount_ratio': int.tryParse(discountRatioController.text.trim()) ?? 0,
      'image': newImageUrl,
      'type': selectedCategory!.name,
      'category_id': selectedCategory!.id,
      'color': colorController.text.trim(),
      'size': sizeController.text.trim(),
      'price_expiry': newExpiryDate,
    };

    try {
      await supabase.from('products').update(updates).eq('id', widget.product['id']);
      await widget.onUpdate();
      Get.back();
      Get.snackbar(ManagerStrings.success, ManagerStrings.updatedSuccessfully);
    } catch (e) {
      Get.snackbar(ManagerStrings.error, '${ManagerStrings.error} ${ManagerStrings.productUpdate}');
    } finally {
      setState(() => isUploading = false);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      backgroundColor: ManagerColors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ManagerStrings.edit,
                style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s22,
                    color: ManagerColors.primaryColor),
              ),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.newProducts, controller: nameController),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.price, controller: priceController, textInputType: TextInputType.number),
               SizedBox(height: ManagerHeight.h12),
              Row(
                children: [
                  Expanded(
                    child: textField(
                      hintText: ManagerStrings.sellingPrice,
                      controller: sellingPriceController,
                      textInputType: TextInputType.number,
                    ),
                  ),
                   SizedBox(width: ManagerWidth.w10),
                  Expanded(
                    child: textField(
                      hintText: ManagerStrings.duration,
                      controller: durationController,
                      textInputType: TextInputType.number,
                    ),
                  ),
                   SizedBox(width: ManagerWidth.w10),
                  DropdownButton<String>(
                    value: selectedUnit,
                    onChanged: (val) => setState(() => selectedUnit = val!),
                    items: ['ثانية', 'دقيقة', 'ساعة', 'يوم', 'اسبوع', 'شهر']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ],
              ),
               SizedBox(height: ManagerHeight.h8),
              Row(
                children: [
                   Text(
                   ManagerStrings.discountExpirationDate,
                    style: getBoldTextStyle(
                        color: ManagerColors.primaryColor,
                        fontSize: ManagerFontSize.s16),
                  ),
                   SizedBox(width: ManagerWidth.w12),
                  Expanded(
                    child: Text(
                      expiryDateText ?? ManagerStrings.notSpecified,
                      style: getRegularTextStyle(
                          color: ManagerColors.blackAccent, fontSize: ManagerFontSize.s16),
                    ),
                  )
                ],
              ),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.discount, controller: discountRatioController, textInputType: TextInputType.number),
               SizedBox(height:ManagerHeight.h12),
              textField(hintText: ManagerStrings.quantity, controller: availableController, textInputType: TextInputType.number),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.code, controller: skuController),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.color, controller: colorController, textInputType: TextInputType.number),
               SizedBox(height: ManagerHeight.h12),
              textField(hintText: ManagerStrings.size, controller: sizeController, textInputType: TextInputType.number),
               SizedBox(height: ManagerHeight.h12),
              DropdownButtonFormField<CategoryModel>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ManagerColors.pinkBackground,
                  labelText: ManagerStrings.choiceCategories,
                  labelStyle:  getRegularTextStyle(

                      color: ManagerColors.primaryColor,
                      fontSize: ManagerFontSize.s16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: ManagerColors.primaryColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: ManagerColors.primaryColor, width: 2),
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
                           SizedBox(width: ManagerWidth.w8),
                          Text(
                            cat.name,
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: ManagerColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
               SizedBox(height: ManagerHeight.h14),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageFile != null
                    ? Image.file(File(imageFile!.path), height: ManagerHeight.h140, width: double.infinity, fit: BoxFit.cover)
                    : oldImageUrl != null
                    ? Image.network(oldImageUrl!, height: ManagerHeight.h140, width: double.infinity, fit: BoxFit.cover)
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
               SizedBox(height: ManagerHeight.h14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManagerColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                icon: const Icon(Icons.image_outlined, color: Colors.white),
                label:  Text(ManagerStrings.choiceImage, style: getRegularTextStyle(color: Colors.white, fontSize: ManagerFontSize.s16)),
                onPressed: () async {
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => imageFile = picked);
                },
              ),
               SizedBox(height: ManagerHeight.h14),
              isUploading
                  ? const LinearProgressIndicator(minHeight: 6, color: ManagerColors.primaryColor)
                  : ElevatedButton.icon(
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManagerColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                icon:  const Icon(Icons.check_circle_outline, color: ManagerColors.white),
                label:  Text(ManagerStrings.productUpdate, style: getRegularTextStyle(color: ManagerColors.white, fontSize: ManagerFontSize.s16)),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
