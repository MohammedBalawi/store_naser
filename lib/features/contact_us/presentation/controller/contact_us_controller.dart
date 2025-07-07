import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';

class ContactUsController extends GetxController {
  final SupabaseClient supabase = getIt<SupabaseClient>();

  String phone = "";
  String location = "";
  String email = "";
  String instagramLink = "";
  String facebookLink = "";
  String twitterLink = "";

  String? selectedContactItem;

  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('contact_us_info')
          .select()
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response.first;
        phone = data['phone'] ?? "";
        email = data['email'] ?? "";
        location = data['location'] ?? "";
        instagramLink = data['instagram_link'] ?? "";
        facebookLink = data['facebook_link'] ?? "";
        twitterLink = data['twitter_link'] ?? "";
      }
      update();
    } catch (e) {
      print('Error fetching contact_us_info: $e');
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
