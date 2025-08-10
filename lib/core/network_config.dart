import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'https://uottransport-3640eafb4db4.herokuapp.com/api/v1/';
//static const String baseUrl = 'http://192.168.1.106:8000/api/v1/';

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
