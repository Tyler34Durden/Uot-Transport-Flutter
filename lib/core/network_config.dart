import 'package:dio/dio.dart';

class NetworkConfig {
static const String baseUrl = 'http://192.168.1.114:8000/api/v1/';

  static Dio createDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return dio;
  }
}
