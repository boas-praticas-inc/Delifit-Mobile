import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Delifit';

  static String get localHost {
    if (kIsWeb) {
      return 'localhost';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return '10.0.2.2';
    }

    return 'localhost';
  }

  static String get apiBaseUrl => 'http://$localHost:8000/api/v1';

  static String get mediaBaseUrl => 'http://$localHost:9000';
}
