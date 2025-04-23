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

// دالة جديدة لتحديث رقم الهاتف (وباقي البيانات) باستخدام API الجديد عبر PUT
  Future<Map<String, dynamic>> updateUserPhone(String token, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.putRequest('user', updatedData, token: token);
      return response.data;
    } on DioError catch (e) {
      logger.e('Error updating user phone: ${e.message}');
      throw Exception('Error updating user phone');
    }
  }
 // دالة تغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword(String token, Map<String, dynamic> passwordData) async {
    try {
      final response = await _apiService.putRequest('user', passwordData, token: token);
      logger.i('Password change response: ${response.data}');
      return response.data;
    } on DioError catch (e) {
      logger.e('Error changing password: ${e.message}');
      throw Exception('Error changing password');
    }
  }
}