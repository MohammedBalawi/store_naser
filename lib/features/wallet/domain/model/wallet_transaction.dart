import 'package:equatable/equatable.dart';

enum TxDirection { in_, out } // in_ = إضافة, out = خصم

class WalletTransaction extends Equatable {
  final String id;
  final DateTime createdAt;
  final TxDirection direction;
  final double amount; // موجب للإضافة, سالب للخصم (نستخدم الاتجاه للّون/الأيقونة)
  final String title;  // مثل: "خصم للطلب رقم #26579639" أو "SHAKE5" أو "ناصر"
  final String? subtitle; // سطر ثانٍ اختياري (صلاحية/وقت إضافي)
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
