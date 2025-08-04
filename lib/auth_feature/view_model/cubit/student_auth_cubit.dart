import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';
import 'package:flutter/material.dart';

class StudentAuthCubit extends Cubit<StudentAuthState> {
  final StudentAuthRepository _studentRepository;

  StudentAuthCubit(this._studentRepository) : super(StudentAuthInitial());

  Future<void> registerStudent(Map<String, dynamic> studentData, BuildContext context) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.registerStudent(studentData);
      emit(RegisterStudentSuccess());
    } catch (e) {
      String errorMessage;
      if (e is DioError && e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is Map && e['message'] != null) {
        errorMessage = e['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is String) {
        // Try to extract {message: ...} from any part of the string
        final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
        final match = regex.firstMatch(e);
        if (match != null) {
          errorMessage = match.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
        } else {
          // Fallback: Try to extract {message: ...} from any part of the string
          final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
          final fallbackMatch = fallbackRegex.firstMatch(e);
          if (fallbackMatch != null) {
            errorMessage = fallbackMatch.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
          } else {
            errorMessage = e.toString().split('\n').first;
          }
        }
      } else {
        errorMessage = e.toString().split('\n').first;
      }
      emit(StudentAuthFailure(errorMessage));
      // Show snackbar for DioError response message if available
      if (e is DioError && e.response != null && e.response?.data != null && e.response?.data['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response!.data['message'].toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> otpData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.verifyOtp(otpData);
      emit(VerifyOtpSuccess());
    } catch (e) {
      String errorMessage = e is Map && e['message'] != null ? e['message'].toString() : e.toString();
      emit(StudentAuthFailure(errorMessage));
    }
  }

  Future<void> login(Map<String, dynamic> loginData) async {
    emit(StudentAuthLoading());
    try {
      print("before repo data in login");
      await _studentRepository.login(loginData);
      print("after repo data in login");
      emit(LoginSuccess());
    } catch (e) {
      String errorMessage = e is Map && e['message'] != null ? e['message'].toString() : e.toString();
      emit(StudentAuthFailure(errorMessage));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(StudentAuthLoading());
    try {
      print("before repo data in forgot password");
      await _studentRepository.forgotPassword(email);
      print("after repo data in forgot password");
      emit(ForgotPasswordSuccess());
    } catch (e) {
      String errorMessage;
      if (e is DioError && e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is Map && e['message'] != null) {
        errorMessage = e['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is String) {
        // Try to extract {message: ...} from any part of the string
        final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
        final match = regex.firstMatch(e);
        if (match != null) {
          errorMessage = match.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
        } else {
          // Fallback: Try to extract {message: ...} from any part of the string
          final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
          final fallbackMatch = fallbackRegex.firstMatch(e);
          if (fallbackMatch != null) {
            errorMessage = fallbackMatch.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
          } else {
            errorMessage = e.toString().split('\n').first;
          }
        }
      } else {
        errorMessage = e.toString().split('\n').first;
      }
      emit(StudentAuthFailure(errorMessage));
    }
  }

  Future<void> validateOtp(Map<String, dynamic> otpData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.validateOtp(otpData);
      emit(ValidateOtpSuccess());
    } catch (e) {
      String errorMessage = e is Map && e['message'] != null ? e['message'].toString() : e.toString();
      emit(StudentAuthFailure(errorMessage));
    }
  }

  Future<void> resetPassword(Map<String, dynamic> passwordData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.resetPassword(passwordData);
      emit(ResetPasswordSuccess());
    } catch (e) {
      String errorMessage = e is Map && e['message'] != null ? e['message'].toString() : e.toString();
      emit(StudentAuthFailure(errorMessage));
    }
  }
}