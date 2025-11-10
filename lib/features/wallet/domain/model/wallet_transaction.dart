import 'package:equatable/equatable.dart';

enum TxDirection { in_, out }

class WalletTransaction extends Equatable {
  final String id;
  final DateTime createdAt;
  final TxDirection direction;
  final double amount;
  final String title;
  final String? subtitle;
  const WalletTransaction({
    required this.id,
    required this.createdAt,
    required this.direction,
    required this.amount,
    required this.title,
    this.subtitle,
  });

  @override
  List<Object?> get props => [id, createdAt, direction, amount, title, subtitle];
}
