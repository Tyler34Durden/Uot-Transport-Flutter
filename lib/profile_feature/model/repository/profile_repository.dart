import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/core/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  ProfileRepository(this._apiService);

  // استرجاع بيانات الملف الشخصي للمستخدم
  Future<Map<String, dynamic>> fetchUserProfile(String token, int userId) async {
    try {
      final response = await _apiService.getRequest('student/profile/$userId', token: token);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException fetching user profile: ${e.message}');
      throw Exception('Error fetching user profile');
    }
  }

// دالة جديدة لتحديث رقم الهاتف (وباقي البيانات) باستخدام API الجديد عبر PUT
  Future<Map<String, dynamic>> updateUserPhone(String token, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.putRequest('user', updatedData, token: token);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException updating user phone: ${e.message}');
      throw Exception('Error updating user phone');
    }
  }
  // دالة تغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword(String token, Map<String, dynamic> passwordData) async {
    try {
      final response = await _apiService.putRequest('user', passwordData, token: token);
      logger.i('Password change response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException changing password: ${e.message}');
      throw Exception('Error changing password');
    }
  }

  Future<void> logout(String token) async {
    try {
      final response = await _apiService.postRequest('user/logout', {}, token: token);
      logger.i('Logout successful: ${response.data}');
    } on DioException catch (e) {
      logger.e('DioException during logout: ${e.message}');
      throw Exception('Error during logout');
    }
  }
}