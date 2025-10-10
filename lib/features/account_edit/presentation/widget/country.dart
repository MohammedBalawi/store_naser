// lib/features/account_edit/presentation/widget/country.dart
class Country {
  final String code;       // SA, KW, AE...
  final String dialCode;   // +966 ...
  final String flagAsset;  // مسار الأيقونة SVG

  const Country({
    required this.code,
    required this.dialCode,
    required this.flagAsset,
  });
}
