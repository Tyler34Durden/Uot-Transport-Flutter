import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';

import 'package:uot_transport/core/api_service.dart';

import '../../domain/entities/auth_login_request.dart';
import '../../domain/entities/auth_register_request.dart';
import '../../domain/entities/otp_request.dart';
import '../../domain/entities/reset_password_request.dart';

class AuthRemoteDatasource {
  final ApiService apiService;
  final Logger _logger = Logger();

  AuthRemoteDatasource(this.apiService);

  Future<String> _getRequiredFcmToken() async {
    if (kIsWeb) {
      _logger.w('FCM token not supported on web, using fallback token');
      return 'web-fallback-token';
    }

    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      await firebaseMessaging.setAutoInitEnabled(true);
    } catch (e) {
      _logger.w('FirebaseMessaging.setAutoInitEnabled failed: $e');
    }

    try {
      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _logger.w('FCM permission denied, using fallback token');
        return 'web-fallback-token';
      }
    } catch (e) {
      _logger.e('FirebaseMessaging.requestPermission failed: $e');
      return 'web-fallback-token';
    }

    String? token;
    try {
      token = await firebaseMessaging.getToken();
    } catch (e) {
      _logger.e('FirebaseMessaging.getToken failed: $e');
      return 'web-fallback-token';
    }

    if (token == null || token.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 800));
      try {
        token = await firebaseMessaging.getToken();
      } catch (e) {
        _logger.e('FirebaseMessaging.getToken retry failed: $e');
        return 'web-fallback-token';
      }
    }

    if (token == null || token.isEmpty) {
      try {
        token = await firebaseMessaging.onTokenRefresh.first.timeout(const Duration(seconds: 5));
      } catch (e) {
        _logger.e('FirebaseMessaging.onTokenRefresh timeout/failed: $e');
        return 'web-fallback-token';
      }
    }

    // at this point token is non-null, but it could still be empty.
    if (token.isEmpty) {
      _logger.w('FCM token unavailable, using fallback token');
      return 'web-fallback-token';
    }

    return token;
  }

  Future<Response> registerStudent(AuthRegisterRequest request) async {
    return apiService.postRequest('student/register', request.toJson());
  }

  Future<Response> verifyOtp(OtpRequest request) async {
    return apiService.postRequest(
        'student/register/verifyOtp', request.toJson());
  }

  Future<Response> login(AuthLoginRequest request) async {
    final fcmToken = await _getRequiredFcmToken();

    final payload = <String, dynamic>{
      ...request.toJson(),
      'fcmToken': fcmToken,
    };

    // Debug logs (safe): don't log password/token values.
    final keys = payload.keys.toList()..sort();
    _logger.i('AuthRemoteDatasource.login payload keys: $keys');
    _logger.i(
        'AuthRemoteDatasource.login has fcmToken: ${payload['fcmToken'] != null && (payload['fcmToken'] as String).isNotEmpty}');

    return apiService.postRequest('student/login', payload);
  }

  Future<Response> forgotPassword(String email) async {
    return apiService.postRequest('forgotPassword', {'email': email});
  }

  Future<Response> validateOtp(OtpRequest request) async {
    return apiService.postRequest('forgotPassword/validateOtp', request.toJson());
  }

  Future<Response> resetPassword(ResetPasswordRequest request) async {
    return apiService.postRequest('resetPassword', request.toJson());
  }
}
