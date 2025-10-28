// File: `lib/core/network_config.dart`
import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'https://api.transport.uot.ly/api/v1/';

  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  /// Build a full URL for an API path (avoids double slashes).
  static String endpoint(String path) {
    if (path.isEmpty) return baseUrl;
    return Uri.parse(baseUrl).resolve(path).toString();
  }
}
