import '../constants/app_constants.dart';

class ImageUrlResolver {
  static const _hostsLocais = {'localhost', '127.0.0.1', '0.0.0.0'};

  static String? resolve(String? rawUrl) {
    final normalized = rawUrl?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(normalized);
    if (uri == null) {
      return normalized;
    }

    if (!uri.hasScheme) {
      final path = normalized.startsWith('/') ? normalized : '/$normalized';
      return '${AppConstants.mediaBaseUrl}$path';
    }

    if (_hostsLocais.contains(uri.host)) {
      return uri.replace(host: AppConstants.localHost).toString();
    }

    return uri.toString();
  }
}
