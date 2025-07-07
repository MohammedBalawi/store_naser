import 'package:flutter/foundation.dart';

class ServerConfig {
  static String getNotificationServerUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000/send-notification';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000/send-notification'; // Android Emulator (or use 10.0.3.2 if needed)
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return 'http://localhost:3000/send-notification';
      default:
        return 'http://localhost:3000/send-notification';
    }
  }
}
