enum WalletTab { total, credit, debit } // المجموع - ائتمان - بدل

enum TxType { in_, out } // داخل/خارج

class WalletTransaction {
  final String id;
  final DateTime createdAt;
  final TxType type; // in_ = +, out = -
  final double amount;
  final String title; // مثل: SHAKES أو "خصم الطلب رقم #26579639"
  final String? note; // مثل: "صالحة حتى 04-04-2025 الساعة 19:35:15"
  WalletTransaction({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.amount,
    required this.title,
    this.note,
  });
}
