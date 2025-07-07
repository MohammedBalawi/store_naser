import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/service/notifications_service.dart';

class ContactUsAdminView extends StatefulWidget {
  const ContactUsAdminView({super.key});

  @override
  State<ContactUsAdminView> createState() => _ContactUsAdminViewState();
}

class _ContactUsAdminViewState extends State<ContactUsAdminView> {
  final SupabaseClient supabase = getIt<SupabaseClient>();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final instagramController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();

  String? recordId;

  @override
  void initState() {
    super.initState();
    fetchContactUsInfo();
  }

  Future<void> fetchContactUsInfo() async {
    try {
      final response = await supabase
          .from('contact_us_info')
          .select()
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response.first;

        recordId = data['id'] as String?;

        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        locationController.text = data['location'] ?? '';
        instagramController.text = data['instagram_link'] ?? '';
        facebookController.text = data['facebook_link'] ?? '';
        twitterController.text = data['twitter_link'] ?? '';

        setState(() {});
      } else {
        print(' No contact_us_info found');
      }
    } catch (e) {
      print(' Error fetching contact_us_info: $e');
    }
  }

  Future<void> saveContactUsInfo() async {
    try {
      final data = {
        'phone': phoneController.text,
        'email': emailController.text,
        'location': locationController.text,
        'instagram_link': instagramController.text,
        'facebook_link': facebookController.text,
        'twitter_link': twitterController.text,
      };

      if (recordId != null) {
        await supabase
            .from('contact_us_info')
            .update(data)
            .eq('id', recordId!);

        Get.snackbar(ManagerStrings.success, ManagerStrings.updatedSuccessfully);
        await addNotification(
          title: 'اضافة موقع لمتجر',
          description: 'تم تحديث بيانات التواصل ',
        );

      } else {
        await supabase.from('contact_us_info').insert(data);

        Get.snackbar(ManagerStrings.success, ManagerStrings.addSuccessfully);

      }

      fetchContactUsInfo();
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      appBar: mainAppBar(title: ManagerStrings.address),
      body: Padding(
        padding: EdgeInsets.all(ManagerHeight.h20),
        child: ListView(
          children: [
            SvgPicture.asset(
              ManagerImages.contactUs,
            ),
            SizedBox(height: ManagerHeight.h20),
            Text(
              ManagerStrings.contactUs,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h20),
            buildTextField(controller: phoneController, label: ManagerStrings.phone),
            buildTextField(controller: emailController, label: ManagerStrings.email),
            buildTextField(controller: locationController, label: ManagerStrings.address),
            buildTextField(controller: instagramController, label: ManagerStrings.instagram),
            buildTextField(controller: facebookController, label: ManagerStrings.facebook),
            buildTextField(controller: twitterController, label: ManagerStrings.twitter),
            SizedBox(height: ManagerHeight.h30),
            mainButton(
              onPressed:(){
                saveContactUsInfo();
                Get.back(result: true);


              } ,
              buttonName: ManagerStrings.saved,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.primaryColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    super.dispose();
  }
}
