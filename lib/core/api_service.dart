// File: lib/core/api_service.dart
    import 'package:dio/dio.dart';
    import 'network_config.dart';
    import 'dart:io';

    class ApiService {
      final Dio _dio = NetworkConfig.createDio();

      Future<Response> getRequest(String endpoint) async {
        try {
          final response = await _dio.get(endpoint);
          print('Status Code: ${response.statusCode}');
          print('Response Data: ${response.data}');
          return response;
        } on DioError catch (e) {
          print('DioError: ${e.message}');
          if (e.response != null) {
            print('Status Code: ${e.response?.statusCode}');
            print('Error Data: ${e.response?.data}');
          }
          rethrow;
        } catch (e) {
          print('Unexpected error: $e');
          rethrow;
        }
      }

      Future<Response> postRequest(String endpoint, Map<String, dynamic> data) async {
        try {
          final response = await _dio.post(endpoint, data: data);
          print('Status Code: ${response.statusCode}');
          print('Response Data: ${response.data}');
          return response;
        } on DioError catch (e) {
          print('DioError: ${e.message}');
          if (e.response != null) {
            print('Status Code: ${e.response?.statusCode}');
            print('Error Data: ${e.response?.data}');
          }
          rethrow;
        } catch (e) {
          print('Unexpected error: $e');
          rethrow;
        }
      }

      void fetchData() async {
        try {
          var response = await _dio.get('https://uottransportserver-28f59bae71b7.herokuapp.com');
          print('Status Code: ${response.statusCode}');
          print('Response Data: ${response.data}');
        } on DioError catch (e) {
          if (e.type == DioErrorType.connectionError && e.error is SocketException) {
            print('Failed to connect to the server. Please check your internet connection.');
          } else {
            print('An error occurred: ${e.message}');
          }
        }
      }
    }