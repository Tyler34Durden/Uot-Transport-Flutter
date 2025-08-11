import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';
import 'package:flutter/material.dart';

class StudentAuthCubit extends Cubit<StudentAuthState> {
  final StudentAuthRepository _studentRepository;

  StudentAuthCubit(this._studentRepository) : super(StudentAuthInitial());

  String _handleError(dynamic e) {
    if (e is DioException) {
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        return errorData['message'];
      }
    }
    return e.toString();
  }

  Future<void> registerStudent(Map<String, dynamic> studentData, BuildContext context) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.registerStudent(studentData);
      emit(RegisterStudentSuccess());
    } catch (e) {
      final errorMessage = _handleError(e);
      emit(StudentAuthFailure(errorMessage));
      if (e is DioException && e.response?.data?['message'] != null) {
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
      emit(StudentAuthFailure(_handleError(e)));
    }
  }

  Future<void> login(Map<String, dynamic> loginData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.login(loginData);
      emit(LoginSuccess());
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 410) {
        emit(SeasonChangeRequired());
        return;
      }
      emit(StudentAuthFailure(_handleError(e)));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.forgotPassword(email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(StudentAuthFailure(_handleError(e)));
    }
  }

  Future<void> validateOtp(Map<String, dynamic> otpData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.validateOtp(otpData);
      emit(ValidateOtpSuccess());
    } catch (e) {
      emit(StudentAuthFailure(_handleError(e)));
    }
  }

  Future<void> resetPassword(Map<String, dynamic> passwordData) async {
    emit(StudentAuthLoading());
    try {
      await _studentRepository.resetPassword(passwordData);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(StudentAuthFailure(_handleError(e)));
    }
  }
}
