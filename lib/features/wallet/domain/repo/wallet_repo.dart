import '../model/wallet_summary.dart';
import '../model/wallet_transaction.dart';

abstract class IWalletRepo {
  Future<WalletSummary> getSummary();
  Future<List<WalletTransaction>> getTransactions();

  Future<bool> redeemVoucher(String code);

  bool get lastRedeemSuccess;
  void clearLastRedeemFlag();
}
