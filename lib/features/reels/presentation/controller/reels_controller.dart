import 'package:get/get.dart';
import '../../data/reels_repository.dart';
import '../../data/models/reel.dart';

class ReelsController extends GetxController {
  ReelsController(this._repo);

  final ReelsRepository _repo;

  final reels = <Reel>[].obs;
  final loading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  Future<void> fetchReels() async {
    try {
      loading.value = true;
      error.value = null;
      final data = await _repo.getReels(page: 1);
      reels.assignAll(data);
    } catch (e) {
      error.value = 'تعذّر جلب الريلز';
    } finally {
      loading.value = false;
    }
  }

  void play(Reel r) {
    // لاحقاً: افتح مشغّل فيديو (video_player/chewie) باستخدام r.videoUrl
  }

  void share(Reel r) {
    // لاحقاً: شارك r.shareUrl عبر share_plus
  }

  void orderNow(Reel r) {
    // نفّذ CTA الشراء حسب منطقك
  }
}
