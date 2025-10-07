class WalletSummary {
  final double total;     // المجموع
  final double credit;    // ائتمان
  final double allowance; // بدل

  const WalletSummary({
    required this.total,
    required this.credit,
    required this.allowance,
  });

  WalletSummary copyWith({double? total, double? credit, double? allowance}) {
    return WalletSummary(
      total: total ?? this.total,
      credit: credit ?? this.credit,
      allowance: allowance ?? this.allowance,
    );
  }
}
