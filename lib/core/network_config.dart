import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'https://uottransportserver-28f59bae71b7.herokuapp.com/api/v1/';

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