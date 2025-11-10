enum WalletTab { total, credit, debit }

enum TxType { in_, out }

class WalletTransaction {
  final String id;
  final DateTime createdAt;
  final TxType type;
  final double amount;
  final String title;
  final String? note;
  WalletTransaction({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.amount,
    required this.title,
    this.note,
  });
}
