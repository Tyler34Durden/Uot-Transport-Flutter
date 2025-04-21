import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/core/api_service.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

  // استرجاع بيانات الملف الشخصي للمستخدم
  Future<Map<String, dynamic>> fetchUserProfile(String token, int userId) async {
    try {
      final response = await _apiService.getRequest('student/profile/$userId', token: token);
      return response.data;
    } on DioError catch (e) {
      logger.e('Error fetching user profile: ${e.message}');
      throw Exception('Error fetching user profile');
    }
  }

  // تحديث بيانات الملف الشخصي للمستخدم
  Future<Map<String, dynamic>> updateUserProfile(String token, int userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.postRequest('student/profile/update/$userId', updatedData, token: token);
      return response.data;
    } on DioError catch (e) {
      logger.e('Error updating user profile: ${e.message}');
      throw Exception('Error updating user profile');
    }
  }
}