import '../model/wallet_summary.dart';
import '../model/wallet_transaction.dart';

abstract class IWalletRepo {
  Future<WalletSummary> getSummary();
  Future<List<WalletTransaction>> getTransactions();

  /// إرجاع true عند نجاح إضافة القسيمة و false عند كونها غير صالحة
  Future<bool> redeemVoucher(String code);

  /// (اختياري) لإظهار توست نجاح في شاشة الرصيد بعد الرجوع من إضافة رصيد
  bool get lastRedeemSuccess;
  void clearLastRedeemFlag();
}
