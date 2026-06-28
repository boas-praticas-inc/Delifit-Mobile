import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Delifit';

  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    return 'http://localhost:8000/api/v1';
  }
}

