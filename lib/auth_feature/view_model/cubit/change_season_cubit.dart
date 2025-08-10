import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:dio/dio.dart';
  import 'package:logger/logger.dart';
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
    final Logger _logger = Logger();
    ChangeSeasonCubit(this.repository) : super(ChangeSeasonInitial());

    Future<void> sendOtp(String email) async {
      emit(ChangeSeasonLoading());
      try {
        await repository.sendOtpRequest(email);
        emit(ChangeSeasonSuccess());
      } catch (e) {
        String errorMsg = _extractErrorMessage(e);
        emit(ChangeSeasonFailure(errorMsg));
      }
    }

    Future<void> validateOtp(String email, String otp) async {
      emit(ChangeSeasonLoading());
      try {
        await repository.validateOtpRequest(email, otp);
        emit(ChangeSeasonSuccess());
      } catch (e) {
        String errorMsg = _extractErrorMessage(e);
        emit(ChangeSeasonFailure(errorMsg));
      }
    }

    Future<void> updateSemester(Map<String, dynamic> data) async {
      emit(ChangeSeasonLoading());
      try {
        await repository.updateSemester(data);
        emit(ChangeSeasonSuccess());
      } catch (e) {
        String errorMsg = _extractErrorMessage(e);
        emit(ChangeSeasonFailure(errorMsg));
      }
    }

    String _extractErrorMessage(dynamic e) {
      if (e is DioError) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData['message'] != null) {
          return errorData['message'].toString();
        }
        return e.toString();
      } else if (e is Map && e['message'] != null) {
        return e['message'].toString();
      } else {
        return e.toString();
      }
    }
  }