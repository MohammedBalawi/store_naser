import 'package:get/get.dart';
import '../../data/reels_repository.dart';
import '../../data/reels_mock_api.dart';
import '../controller/reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    // بدّل ReelsMockApi بأي تنفيذ حقيقي بدون لمس بقية الطبقات
    Get.lazyPut(() => ReelsRepository(ReelsMockApi()));
    Get.put(ReelsController(Get.find<ReelsRepository>()));
  }
}
