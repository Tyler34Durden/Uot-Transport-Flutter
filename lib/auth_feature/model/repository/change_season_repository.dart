import '../../../core/api_service.dart';
import 'package:logger/logger.dart';

class ChangeSeasonRepository {
  final ApiService _apiService;
  final Logger logger = Logger();
  ChangeSeasonRepository([ApiService? apiService]) : _apiService = apiService ?? ApiService();

  Future<void> sendOtpRequest(String email) async {
    final data = {'email': email};
    try {
      logger.i('Sending OTP request for email: $email');
      final response = await _apiService.postRequest('semester/update/otp', data);
      logger.i('OTP request response: ${response.data}');
    } catch (e, stack) {
      logger.e('OTP request failed: $e\nStack: $stack');
      throw e;
    }
  }
  Future<void> validateOtpRequest(String email, String otp) async {
    final data = {'email': email, 'otp': otp};
    try {
      logger.i('Validating OTP for email: $email, otp: $otp');
      final response = await _apiService.postRequest('semester/update/validateOtp', data);
      logger.i('Validate OTP response: ${response.data}');
    } catch (e, stack) {
      logger.e('Validate OTP failed: $e\nStack: $stack');
      throw e;
    }
  }
  Future<void> updateSemester(Map<String, dynamic> data) async {
    try {
      logger.i('Updating semester with data: $data');
      final response = await _apiService.postRequest('semester/update', data);
      logger.i('Update semester response: ${response.data}');
    } catch (e, stack) {
      logger.e('Update semester failed: $e\nStack: $stack');
      throw e;
    }
  }
}
