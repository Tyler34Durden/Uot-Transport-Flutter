import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'http://156.38.56.111:8002/api/v1/';
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
