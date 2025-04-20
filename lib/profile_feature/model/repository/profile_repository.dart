import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/core/api_service.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

  Future<Response> fetchUserProfile(String token, int id) async {
    try {
      _apiService.dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _apiService.getRequest('/user/$id');
      logger.i('User profile fetched successfully: ${response.data}');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in fetchUserProfile: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

 Future<Response> updateUserProfile(
    String token,
    int userId,
    Map<String, dynamic> payload,
  ) async {
    try {
      _apiService.dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _apiService.putRequest('/user/$userId', payload);
      logger.i('User profile updated successfully: ${response.data}');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in updateUserProfile: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }




}