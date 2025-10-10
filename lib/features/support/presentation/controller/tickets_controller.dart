import 'dart:typed_data';
import 'package:get/get.dart';
import '../../domain/models/support_models.dart';
import '../../domain/repo/support_repo.dart';

class TicketsController extends GetxController {
  TicketsController(this._repo);
  final SupportRepo _repo;

  final isLoading = true.obs;
  final tickets = <SupportTicket>[].obs;

  // فتح تذكرة
  final orderId = ''.obs;                 // يظهر أعلى الفورم
  final selectedProblem = ''.obs;         // ما هي مشكلتك؟
  final details = ''.obs;                 // التفاصيل
  Uint8List? attachedImage;               // مرفق (اختياري)

  bool get canSubmit =>
      selectedProblem.value.isNotEmpty && details.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  Future<void> loadTickets() async {
    isLoading.value = true;
    tickets.assignAll(await _repo.fetchTickets());
    isLoading.value = false;
  }

  void chooseProblem(String value) {
    selectedProblem.value = value;
    update();
  }

  void setDetails(String v) {
    details.value = v;
  }

  void attachImage(Uint8List bytes) {
    attachedImage = bytes;
    update();
  }

  void removeImage() {
    attachedImage = null;
    update();
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;
    final t = await _repo.createTicket(
      orderId: orderId.value.isEmpty ? '26579639' : orderId.value,
      problemTitle: selectedProblem.value,
      details: details.value,
      imagePath: null, // TODO: ارفع الصورة لو عندك تخزين
    );
    tickets.insert(0, t);
    // reset
    selectedProblem.value = '';
    details.value = '';
    attachedImage = null;
    update();
    return true;
  }
}
