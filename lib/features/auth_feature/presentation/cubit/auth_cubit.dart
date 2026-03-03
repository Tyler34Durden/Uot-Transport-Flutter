import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../../domain/entities/auth_login_request.dart';
import '../../domain/entities/auth_register_request.dart';
import '../../domain/entities/otp_request.dart';
import '../../domain/entities/reset_password_request.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/validate_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ValidateOtpUseCase validateOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.forgotPasswordUseCase,
    required this.validateOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(const AuthState.initial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthState.loading());
    final result = await loginUseCase(AuthLoginRequest(email: email, password: password));
    result.fold(
      (failure) {
        // If backend indicates the semester/year must be updated first, route UI to change season flow.
        if (failure is ApiFailure && failure.statusCode == 410) {
          emit(const AuthState.seasonChangeRequired());
          return;
        }
        emit(AuthState.failure(message: failure.message));
      },
      (student) => emit(AuthState.loginSuccess(student: student)),
    );
  }

  Future<void> register(AuthRegisterRequest request) async {
    emit(const AuthState.loading());
    final result = await registerUseCase(request);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.message)),
      (_) => emit(const AuthState.registerSuccess()),
    );
  }

  Future<void> verifyOtp(OtpRequest request) async {
    emit(const AuthState.loading());
    final result = await verifyOtpUseCase(request);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.message)),
      (_) => emit(const AuthState.verifyOtpSuccess()),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());
    final result = await forgotPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.message)),
      (_) => emit(const AuthState.forgotPasswordSuccess()),
    );
  }

  Future<void> validateOtp(OtpRequest request) async {
    emit(const AuthState.loading());
    final result = await validateOtpUseCase(request);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.message)),
      (_) => emit(const AuthState.validateOtpSuccess()),
    );
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    emit(const AuthState.loading());
    final result = await resetPasswordUseCase(request);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.message)),
      (_) => emit(const AuthState.resetPasswordSuccess()),
    );
  }
}
