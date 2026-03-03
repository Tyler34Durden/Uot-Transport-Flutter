import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/student_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _AuthInitial;
  const factory AuthState.loading() = _AuthLoading;

  const factory AuthState.failure({required String message}) = _AuthFailure;

  const factory AuthState.loginSuccess({required StudentEntity student}) = _AuthLoginSuccess;
  const factory AuthState.registerSuccess() = _AuthRegisterSuccess;
  const factory AuthState.verifyOtpSuccess() = _AuthVerifyOtpSuccess;
  const factory AuthState.forgotPasswordSuccess() = _AuthForgotPasswordSuccess;
  const factory AuthState.validateOtpSuccess() = _AuthValidateOtpSuccess;
  const factory AuthState.resetPasswordSuccess() = _AuthResetPasswordSuccess;

  /// Returned when backend requires the student to update semester/year before login.
  const factory AuthState.seasonChangeRequired() = _AuthSeasonChangeRequired;
}
