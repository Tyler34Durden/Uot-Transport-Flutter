import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';

import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/auth_login_request.dart';
import '../../domain/entities/auth_login_response.dart';
import '../../domain/entities/auth_register_request.dart';
import '../../domain/entities/otp_request.dart';
import '../../domain/entities/reset_password_request.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  const AuthRepositoryImpl(this.remote);

  @override

  ResultFuture<StudentEntity> login(AuthLoginRequest request) async {
    try {
      final response = await remote.login(request);

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw {
          'message': 'Invalid response format',
          'statusCode': response.statusCode ?? 500
        };
      }

      final parsed = AuthLoginResponse.fromJson(data);

      // Persist token + user id for the rest of the app.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', parsed.token);
      await prefs.setInt('user_id', parsed.user.id);
      await prefs.setString('user_profile', jsonEncode(parsed.user.toJson()));

      return Right(parsed.user.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid register(AuthRegisterRequest request) async {
    try {
      await remote.registerStudent(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid verifyOtp(OtpRequest request) async {
    try {
      await remote.verifyOtp(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid validateOtp(OtpRequest request) async {
    try {
      await remote.validateOtp(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid resetPassword(ResetPasswordRequest request) async {
    try {
      await remote.resetPassword(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid forgotPassword(String email) async {
    try {
      await remote.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic e) {
    if (e is Map && e['message'] != null) {
      return ApiFailure(
        message: e['message'].toString(),
        statusCode: (e['statusCode'] as int?) ?? 500,
      );
    }
    if (e is DioException) {
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        return ApiFailure(
          message: errorData['message'].toString(),
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      return ApiFailure(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
    return ApiFailure(message: e.toString(), statusCode: 500);
  }
}
