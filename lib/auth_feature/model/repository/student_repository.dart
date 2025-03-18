// File: lib/auth_feature/model/repository/student_repository.dart
import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';

class StudentRepository {
  final ApiService _apiService = ApiService();

  Future<Response> registerStudent(Map<String, dynamic> studentData) async {
    try {
      return await _apiService.postRequest('student/register', studentData);
    } on DioError catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        print('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> verifyOtp(Map<String, dynamic> otpData) async {
    try {
      return await _apiService.postRequest(
          'student/register/verifyOtp', otpData);
    } on DioError catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        print('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

 Future<Response> login(Map<String, dynamic> loginData) async {
    try {
      return await _apiService.postRequest('student/login', loginData);
    } on DioError catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        print('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  
}
