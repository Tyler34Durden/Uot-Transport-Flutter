//added after removed
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class StudentAuthRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

  Future<String> _getRequiredFcmToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      await firebaseMessaging.setAutoInitEnabled(true);
    } catch (e) {
      logger.w('FirebaseMessaging.setAutoInitEnabled failed: $e');
    }

    NotificationSettings settings;
    try {
      settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      logger.w('FirebaseMessaging.requestPermission failed: $e');
      throw {
        'message':
            'تعذر تهيئة الإشعارات. تأكد من إعدادات Firebase وحاول مرة أخرى.'
      };
    }

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      throw {
        'message': 'الإشعارات معطلة. يرجى تفعيل الإشعارات للتسجيل والدخول.'
      };
    }

    String? token;
    try {
      token = await firebaseMessaging.getToken();
    } catch (e) {
      logger.w('FirebaseMessaging.getToken failed: $e');
    }

    if (token == null || token.isEmpty) {
      // Give iOS (APNs) a moment, then retry.
      await Future.delayed(const Duration(milliseconds: 800));
      try {
        token = await firebaseMessaging.getToken();
      } catch (e) {
        logger.w('FirebaseMessaging.getToken retry failed: $e');
      }
    }

    if (token == null || token.isEmpty) {
      // Last attempt: wait briefly for a refresh event.
      try {
        token = await firebaseMessaging.onTokenRefresh.first
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        logger.w('FirebaseMessaging.onTokenRefresh timeout/failed: $e');
      }
    }

    if (token == null || token.isEmpty) {
      throw {
        'message':
            'تعذر الحصول على رمز الإشعارات (FCM). يرجى المحاولة لاحقاً أو إعادة تشغيل التطبيق.'
      };
    }

    return token;
  }

  Future<Response> registerStudent(Map<String, dynamic> studentData) async {
    try {
      final response =
          await _apiService.postRequest('student/register', studentData);
      logger.i('Student registered successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
        throw e.response?.data;
      }
      rethrow;
    }
  }

  Future<Response> verifyOtp(Map<String, dynamic> otpData) async {
    try {
      final response =
          await _apiService.postRequest('student/register/verifyOtp', otpData);
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

  // Future<Response> login(Map<String, dynamic> loginData) async {
  //   try {
  //     final response =
  //         await _apiService.postRequest('student/login', loginData);
  //     final token = response.data['token'];
  //     final user = response.data['user'];
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('auth_token', token);
  //     await prefs.setString(
  //         'user_profile', jsonEncode(user)); // تخزين بيانات المستخدم بالكامل
  //     logger.i('Token saved: $token and user data saved: $user');
  //     return response;
  //   } on DioError catch (e) {
  //     logger.e('DioError: ${e.message}');
  //     if (e.response != null) {
  //       logger.e('DioError Response: ${e.response?.data}');
  //     }
  //     rethrow;
  //   }
  // }

  Future<Response> login(Map<String, dynamic> loginData) async {
    try {
      // الحصول على رمز FCM وإضافته إلى بيانات تسجيل الدخول (مطلوب من السيرفر)
      final String fcmToken = await _getRequiredFcmToken();
      logger.i('FCM Token obtained: $fcmToken');
      loginData['fcmToken'] = fcmToken;
      logger.i('Login data being sent: ' + loginData.toString());
      final response =
          await _apiService.postRequest('student/login', loginData);
      // Print the full notification response for debugging
      logger.i('Login response: ' + response.toString());
      final token = response.data['token'];
      final user = response.data['user'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_profile', jsonEncode(user));
      logger.i(
          'Token saved: $token, user data saved: $user, and FCM Token: $fcmToken');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: [31m${e.message}[0m');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
        //throw e.response?.data;
        throw {'statusCode': e.response?.statusCode, ...?e.response?.data};
      }
      rethrow;
    }
  }

  Future<Response> forgotPassword(String email) async {
    try {
      final response =
          await _apiService.postRequest('forgotPassword', {'email': email});
      logger.i('Forgot password request sent successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> validateOtp(Map<String, dynamic> otpData) async {
    try {
      final response =
          await _apiService.postRequest('forgotPassword/validateOtp', otpData);
      logger.i('OTP validated successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> resetPassword(Map<String, dynamic> passwordData) async {
    try {
      final response =
          await _apiService.postRequest('resetPassword', passwordData);
      logger.i('Password reset successfully');
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
