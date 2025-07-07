import 'package:flutter/material.dart';

/// Non Null String to handle the null safety for string
extension NonNullString on String? {
  String onNull() {
    if (this == null) {
      return '';
    } else {
      return this!;
    }
  }
}

/// Non Null Locale to handle the null safety for local(string)
extension NonNullLocale on String? {
  String pareWithDefaultLocale() {
    if (this == null) {
      return 'ar';
    } else {
      return this!;
    }
  }
}

extension NonNullBool on bool? {
  bool onNull() {
    if (this == null) {
      return false;
    } else {
      return this!;
    }
  }
}

/// Non Null Bool to handle the null safety for bool
extension NonNullBoolNotification on bool? {
  bool onNotify() {
    if (this == null) {
      return true;
    } else {
      return this!;
    }
  }
}

/// Non Null Double to handle the null safety for double
extension NonNullDouble on double? {
  double onNull() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }
}

/// Non Null Int to handle the null safety for integers
extension NonNullInt on int? {
  int onNull() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }
}

/// Non Null list to handle the null safety for lists
extension NonNullList<T> on List<T>? {
  List<T> onNull() {
    if (this == null) {
      return [];
    } else {
      return this!;
    }
  }
}

/// Non Null Function to handle the null safety for functions
extension NonNullFunction on Function()? {
  Function() onNull() {
    if (this == null) {
      return () {};
    } else {
      return this!;
    }
  }
}

/// Non Null DateTime to handle the null safety for dates,times
extension NonNullDateTime on DateTime? {
  DateTime onNull() {
    if (this == null) {
      return DateTime.now();
    } else {
      return this!;
    }
  }
}

/// Extension to capitalize the first letter for string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

/// On Null Bool to handle the null safety for bool from env(UnKnownType)
extension OnNullBool on String? {
  bool onNullBool() {
    if (this == null) {
      return false;
    } else {
      return bool.parse(this!);
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension StringHtmlExtension on String {
  String removeHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
