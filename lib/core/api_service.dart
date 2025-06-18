import 'package:dio/dio.dart';
import 'network_config.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = NetworkConfig.createDio();
  final Logger logger = Logger();

  Dio get dio => _dio;

  Future<String?> _getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Response> getRequest(String endpoint, {String? token, Map<String, dynamic>? queryParams}) async {
    token ??= await _getTokenFromPrefs();
    print('Bearer token used in GET: $token');
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      logger.i('GET $endpoint');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      _logDioError(e, endpoint);
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> data, {String? token}) async {
    token ??= await _getTokenFromPrefs();
    print('Bearer token used in POST: $token');
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      logger.i('POST $endpoint');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      _logDioError(e, endpoint);
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  Future<Response> putRequest(String endpoint, Map<String, dynamic> data, {String? token}) async {
    token ??= await _getTokenFromPrefs();
    print('Bearer token used in PUT: $token');
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 400,
        ),
      );
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          logger.w('Redirecting to $redirectUrl');
          return await _dio.get(redirectUrl);
        }
      }
      logger.i('PUT $endpoint');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      _logDioError(e, endpoint);
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  Future<Response> patchRequest(String endpoint, Map<String, dynamic> data, {String? token}) async {
    token ??= await _getTokenFromPrefs();
    print('Bearer token used in PATCH: $token');
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      logger.i('PATCH $endpoint');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Data: ${response.data}');
      return response;
    } on DioError catch (e) {
      _logDioError(e, endpoint);
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  void _logDioError(DioError e, String endpoint) {
    logger.e('DioError on $endpoint: ${e.message}');
    if (e.response != null) {
      logger.e('Status Code: ${e.response?.statusCode}');
      logger.e('Error Data: ${e.response?.data}');
    }
  }
}