import 'package:get/get.dart';
import '../../../../core/routes/routes.dart';

class AboutController extends GetxController {
  final String hotline = '+966 588986285';
  final String email = 'support@example.com';

  void toTechSupport() {
    Get.toNamed(
        Routes.supportTech
    );
  }
  void callCustomerService() {
    // TODO: launchUrl('tel:$hotline');
  }
  void openWhatsApp() {
    // TODO: launchUrl('https://wa.me/966588986285');
  }
  void mailUs() {
    // TODO: launchUrl('mailto:$email');
  }
}
