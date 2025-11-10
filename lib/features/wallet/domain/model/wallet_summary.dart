class WalletSummary {
  final double total;
  final double credit;
  final double allowance;

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
