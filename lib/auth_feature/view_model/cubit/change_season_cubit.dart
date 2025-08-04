import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../model/repository/change_season_repository.dart';

abstract class ChangeSeasonState {}
class ChangeSeasonInitial extends ChangeSeasonState {}
class ChangeSeasonLoading extends ChangeSeasonState {}
class ChangeSeasonSuccess extends ChangeSeasonState {}
class ChangeSeasonFailure extends ChangeSeasonState {
  final String error;
  ChangeSeasonFailure(this.error);
}

class ChangeSeasonCubit extends Cubit<ChangeSeasonState> {
  final ChangeSeasonRepository repository;
  ChangeSeasonCubit(this.repository) : super(ChangeSeasonInitial());

  Future<void> sendOtp(String email) async {
    emit(ChangeSeasonLoading());
    try {
      await repository.sendOtpRequest(email);
      emit(ChangeSeasonSuccess());
    } catch (e) {
      String errorMsg;
      if (e is DioError && e.response?.data != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is Map && e['message'] != null) {
        errorMsg = e['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is String) {
        final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
        final match = regex.firstMatch(e);
        if (match != null) {
          errorMsg = match.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
        } else {
          final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
          final fallbackMatch = fallbackRegex.firstMatch(e);
          if (fallbackMatch != null) {
            errorMsg = fallbackMatch.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
          } else {
            errorMsg = e.toString().split('\n').first;
          }
        }
      } else {
        errorMsg = e.toString().split('\n').first;
      }
      emit(ChangeSeasonFailure(errorMsg));
    }
  }

  Future<void> validateOtp(String email, String otp) async {
    emit(ChangeSeasonLoading());
    try {
      await repository.validateOtpRequest(email, otp);
      emit(ChangeSeasonSuccess());
    } catch (e) {
      String errorMsg;
      if (e is DioError && e.response?.data != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is Map && e['message'] != null) {
        errorMsg = e['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is String) {
        final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
        final match = regex.firstMatch(e);
        if (match != null) {
          errorMsg = match.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
        } else {
          final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
          final fallbackMatch = fallbackRegex.firstMatch(e);
          if (fallbackMatch != null) {
            errorMsg = fallbackMatch.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
          } else {
            errorMsg = e.toString().split('\n').first;
          }
        }
      } else {
        errorMsg = e.toString().split('\n').first;
      }
      emit(ChangeSeasonFailure(errorMsg));
    }
  }

  Future<void> updateSemester(Map<String, dynamic> data, BuildContext context) async {
    emit(ChangeSeasonLoading());
    try {
      await repository.updateSemester(data);
      emit(ChangeSeasonSuccess());
    } catch (e) {
      String errorMsg;
      if (e is DioError && e.response?.data != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is Map && e['message'] != null) {
        errorMsg = e['message']?.toString() ?? 'حدث خطأ غير متوقع';
      } else if (e is String) {
        final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
        final match = regex.firstMatch(e);
        if (match != null) {
          errorMsg = match.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
        } else {
          final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
          final fallbackMatch = fallbackRegex.firstMatch(e);
          if (fallbackMatch != null) {
            errorMsg = fallbackMatch.group(1)?.trim() ?? 'حدث خطأ غير متوقع';
          } else {
            errorMsg = e.toString().split('\n').first;
          }
        }
      } else {
        errorMsg = e.toString().split('\n').first;
      }
      emit(ChangeSeasonFailure(errorMsg));
    }
  }
}
