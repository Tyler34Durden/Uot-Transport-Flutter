// // File: lib/core/api_service.dart
//     // ignore_for_file: avoid_print

//     import 'package:dio/dio.dart';
//     import 'network_config.dart';
//     import 'dart:io';

//     class ApiService {
//       final Dio _dio = NetworkConfig.createDio();

//       Future<Response> getRequest(String endpoint) async {
//         try {
//           final response = await _dio.get(endpoint);
//           print('Status Code: ${response.statusCode}');
//           print('Response Data: ${response.data}');
//           return response;
//         } on DioError catch (e) {
//           print('DioError: ${e.message}');
//           if (e.response != null) {
//             print('Status Code: ${e.response?.statusCode}');
//             print('Error Data: ${e.response?.data}');
//           }
//           rethrow;
//         } catch (e) {
//           print('Unexpected error: $e');
//           rethrow;
//         }
//       }

//       Future<Response> postRequest(String endpoint, Map<String, dynamic> data) async {
//         try {
//           final response = await _dio.post(endpoint, data: data);
//           print('Status Code: ${response.statusCode}');
//           print('Response Data: ${response.data}');
//           return response;
//         } on DioError catch (e) {
//           print('DioError: ${e.message}');
//           if (e.response != null) {
//             print('Status Code: ${e.response?.statusCode}');
//             print('Error Data: ${e.response?.data}');
//           }
//           rethrow;
//         } catch (e) {
//           print('Unexpected error: $e');
//           rethrow;
//         }
//       }

//       void fetchData() async {
//         try {
//           var response = await _dio.get('https://uottransportserver-28f59bae71b7.herokuapp.com');
//           print('Status Code: ${response.statusCode}');
//           print('Response Data: ${response.data}');
//         } on DioError catch (e) {
//           if (e.type == DioErrorType.connectionError && e.error is SocketException) {
//             print('Failed to connect to the server. Please check your internet connection.');
//           } else {
//             print('An error occurred: ${e.message}');
//           }
//         }
//       }
//     }

import 'package:dio/dio.dart';
import 'network_config.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class ApiService {
  final Dio _dio = NetworkConfig.createDio();
  final Logger logger = Logger();

  Dio get dio => _dio;

  Future<Response> getRequest(String endpoint, {String? token}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null),
      );
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('Status Code: ${e.response?.statusCode}');
        logger.e('Error Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null),
      );
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('Status Code: ${e.response?.statusCode}');
        logger.e('Error Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  // Future<Response> putRequest(String endpoint, Map<String, dynamic> data, {String? token}) async {
  //   try {
  //     final response = await _dio.put(
  //       endpoint,
  //       data: data,
  //       options: Options(headers: token != null ? {'Authorization': 'Bearer $token'} : null),
  //     );
  //     logger.i('Status Code: ${response.statusCode}');
  //     logger.i('Response Data: ${response.data}');
  //     return response;
  //   } on DioError catch (e) {
  //     logger.e('DioError: ${e.message}');
  //     if (e.response != null) {
  //       logger.e('Status Code: ${e.response?.statusCode}');
  //       logger.e('Error Data: ${e.response?.data}');
  //     }
  //     rethrow;
  //   } catch (e) {
  //     logger.e('Unexpected error: $e');
  //     rethrow;
  //   }
  // }

  Future<Response> putRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) =>
              status != null && status < 400, // قبول أي حالة أقل من 400
          followRedirects: false, // تعطيل المتابعة التلقائية لإعادة التوجيه
        ),
      );
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('Status Code: ${e.response?.statusCode}');
        logger.e('Error Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  void fetchData() async {
    try {
      var response = await _dio
          .get('https://uottransportserver-28f59bae71b7.herokuapp.com');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionError &&
          e.error is SocketException) {
        logger.e(
            'Failed to connect to the server. Please check your internet connection.');
      } else {
        logger.e('An error occurred: ${e.message}');
      }
    }
  }
}
