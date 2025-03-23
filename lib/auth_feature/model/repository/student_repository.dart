import 'package:dio/dio.dart';
      import 'package:shared_preferences/shared_preferences.dart';
      import 'package:uot_transport/core/api_service.dart';
      import 'package:logger/logger.dart';

      class StudentRepository {
        final ApiService _apiService = ApiService();
        final logger = Logger();

        Future<Response> registerStudent(Map<String, dynamic> studentData) async {
          try {
            final response = await _apiService.postRequest('student/register', studentData);
            logger.i('Student registered successfully');
            return response;
          } on DioError catch (e) {
            logger.e('DioError: ${e.message}');
            if (e.response != null) {
              logger.e('DioError Response: ${e.response?.data}');
            }
            rethrow;
          }
        }

        Future<Response> verifyOtp(Map<String, dynamic> otpData) async {
          try {
            final response = await _apiService.postRequest('student/register/verifyOtp', otpData);
            logger.i('OTP verified successfully');
            return response;
          } on DioError catch (e) {
            logger.e('DioError: ${e.message}');
            if (e.response != null) {
              logger.e('DioError Response: ${e.response?.data}');
            }
            rethrow;
          }
        }

        Future<Response> login(Map<String, dynamic> loginData) async {
          try {
            final response = await _apiService.postRequest('student/login', loginData);
            // Assuming the token is in the response data
            final token = response.data['token'];
            // Save the token using shared_preferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            logger.i('Token saved: $token');
            return response;
          } on DioError catch (e) {
            logger.e('DioError: ${e.message}');
            if (e.response != null) {
              logger.e('DioError Response: ${e.response?.data}');
            }
            rethrow;
          }
        }
      }