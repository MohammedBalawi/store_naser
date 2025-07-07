import 'dart:io';
import 'package:app_mobile/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/main_button.dart';

import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/service/notifications_service.dart';
import '../controller/profile_controller.dart';

class UploadProfileImageView extends StatefulWidget {
  const UploadProfileImageView({super.key});

  @override
  State<UploadProfileImageView> createState() => _UploadProfileImageViewState();
}

class _UploadProfileImageViewState extends State<UploadProfileImageView> {
  XFile? imageFile;
  String? existingImageUrl;
  final picker = ImagePicker();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    loadExistingImage();
  }

  Future<void> loadExistingImage() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('image')
          .eq('id', user.id)
          .maybeSingle();
      if (response != null && response['image'] != null) {
        setState(() => existingImageUrl = response['image']);
      }
    }
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = picked);
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.noImageSelected);
      return;
    }

    try {
      setState(() => isUploading = true);
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
        return;
      }

      final fileExt = imageFile!.path.split('.').last;
      final filePath = 'profile/${const Uuid().v4()}.$fileExt';
      final bytes = await imageFile!.readAsBytes();

      await supabase.storage
          .from('product-images')
          .uploadBinary(filePath, bytes);
      final imageUrl =
          supabase.storage.from('product-images').getPublicUrl(filePath);

      if (existingImageUrl != null) {
        final path =
            Uri.parse(existingImageUrl!).pathSegments.skip(1).join('/');
        await supabase.storage.from('product-images').remove([path]);
      }

      await supabase
          .from('users')
          .update({'image': imageUrl}).eq('id', user.id);

      final controller = Get.put(ProfileController());
      await controller.fetchUserDataFromSupabase();
      await controller.loadExistingImage();
      controller.update();

      Get.snackbar(ManagerStrings.success, ManagerStrings.updatedSuccessfully);

      // Get.offAllNamed('/editProfile');
      Navigator.of(context).pop();


    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.failedUpdated);
    } finally {
      setState(() => isUploading = false);
    }
  }

  void showImageOptionsDialog() {
    Get.defaultDialog(
      title: ManagerStrings.choiceImage,
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title:  Text(ManagerStrings.delete),
            onTap: () async {
              if (existingImageUrl != null) {
                final path =
                    Uri.parse(existingImageUrl!).pathSegments.skip(1).join('/');
                await Supabase.instance.client.storage
                    .from('product-images')
                    .remove([path]);
                await Supabase.instance.client
                    .from('users')
                    .update({'image': null}).eq(
                        'id', Supabase.instance.client.auth.currentUser!.id);
                setState(() => existingImageUrl = null);
              }
              await addNotification(
                title: 'رفع صورة ',
                description: 'تمت تحديث الصورة بنجاح',
              );

              Get.back();
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.check_circle_outline, color: Colors.green),
            title:  Text(ManagerStrings.setProfileImage),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ManagerColors.white,
        title: Text(
          ManagerStrings.update,
          style: getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.primaryColor),
        ),
      ),
      backgroundColor: ManagerColors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(ManagerWidth.w20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: ManagerRadius.r60,
                    backgroundImage: imageFile != null
                        ? FileImage(File(imageFile!.path))
                        : (existingImageUrl != null
                            ? NetworkImage(existingImageUrl!)
                            : null) as ImageProvider?,
                    backgroundColor: ManagerColors.pinkBackground,
                    child: (imageFile == null && existingImageUrl == null)
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: existingImageUrl != null
                          ? showImageOptionsDialog
                          : null,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ManagerColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.more_vert,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              mainButton(
                buttonName: ManagerStrings.choiceImage,
                onPressed: pickImage,
              ),
              const SizedBox(height: 20),
              isUploading
                  ? const CircularProgressIndicator(
                      color: ManagerColors.primaryColor)
                  : mainButton(
                      buttonName: ManagerStrings.saved,
                      onPressed: uploadImage,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
