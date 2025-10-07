// lib/features/addressess/domain/model/address.dart
class Address {
  final String id;
  final String fullName;
  final String phone;
  final String prettyAddress; // نص العنوان المختصر لعرضه
  final bool isPrimary;

  Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.prettyAddress,
    this.isPrimary = false,
  });

  Address copyWith({bool? isPrimary}) =>
      Address(
        id: id,
        fullName: fullName,
        phone: phone,
        prettyAddress: prettyAddress,
        isPrimary: isPrimary ?? this.isPrimary,
      );
}
