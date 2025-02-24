import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'https://api.example.com';


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