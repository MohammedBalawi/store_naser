import 'package:get/get.dart';
import '../../domain/entities/transaction.dart';

enum VoucherBanner { none, invalid, success }

class WalletController extends GetxController {
  final currentTab = WalletTab.total.obs;
  final balanceTotal = 0.0.obs;
  final balanceCredit = 0.0.obs;
  final balanceDebit  = 0.0.obs;

  // المعاملات
  final transactions = <WalletTransaction>[].obs;

  // حالة إشعار أعلى الشاشة
  final bannerState = VoucherBanner.none.obs;
  final bannerText  = ''.obs;

  // نموذج رمز القسيمة
  final voucherCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _seedDemoData(); // بيانات مطابقة للصور لمعاينة الشاشة
  }

  void changeTab(WalletTab tab) {
    currentTab.value = tab;
  }

  List<WalletTransaction> get filtered {
    switch (currentTab.value) {
      case WalletTab.total:
        return transactions;
      case WalletTab.credit:
        return transactions.where((t) => t.type == TxType.in_).toList();
      case WalletTab.debit:
        return transactions.where((t) => t.type == TxType.out).toList();
    }
  }

  void _recalc() {
    final inSum  = transactions.where((t) => t.type == TxType.in_).fold<double>(0.0, (s, t) => s + t.amount);
    final outSum = transactions.where((t) => t.type == TxType.out).fold<double>(0.0, (s, t) => s + t.amount);
    balanceCredit.value = inSum;
    balanceDebit.value  = outSum;
    balanceTotal.value  = inSum - outSum;
  }

  // إضافة رصيد بعد التحقق
  Future<void> redeemVoucher() async {
    bannerState.value = VoucherBanner.none;
    bannerText.value  = '';
    final code = voucherCode.value.trim();

    // محاكاة تحقق — غيّرها لاحقًا باستدعاء API
    await 200.milliseconds.delay();
    final isValid = code == 'NSA-FSZ4IYLW'; // نفس الكود في الصورة

    if (!isValid) {
      bannerState.value = VoucherBanner.invalid;
      bannerText.value  = 'رمز القسيمة الذي أدخلته غير صالح';
      return;
    }

    // نجاح: أضف معاملة +5.00 بنفس النصوص
    final now = DateTime(2025, 4, 1, 13, 46, 10);
    transactions.insert(0, WalletTransaction(
      id: 'tx_in_demo',
      createdAt: now,
      type: TxType.in_,
      amount: 5.0,
      title: 'ناثر', // بالصورة “ناثر” أو اسم الجهة
      note: 'صالحة حتى 04-04-2025 الساعة 19:35:15.',
    ));
    _recalc();

    bannerState.value = VoucherBanner.success;
    bannerText.value  = 'لقد تمت إضافة رصيدك بنجاح';
  }

  void dismissBanner() {
    bannerState.value = VoucherBanner.none;
    bannerText.value  = '';
  }

  void _seedDemoData() {
    final base = DateTime(2025, 4, 1, 13, 46, 10);

    transactions.assignAll([
      WalletTransaction(
        id: 'tx_out_1',
        createdAt: base,
        type: TxType.out,
        amount: 5.0,
        title: 'خصم الطلب رقم #26579639',
        note: null,
      ),
      WalletTransaction(
        id: 'tx_in_1',
        createdAt: base,
        type: TxType.in_,
        amount: 5.0,
        title: 'SHAKES',
        note: 'صالحة حتى 04-04-2025 الساعة 19:35:15.',
      ),
    ]);

    _recalc();
  }
}
