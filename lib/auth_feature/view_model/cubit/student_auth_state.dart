class StudentAuthState {}

class StudentAuthInitial extends StudentAuthState {}

class StudentAuthLoading extends StudentAuthState {}

// Specific success states for each operation
class RegisterStudentSuccess extends StudentAuthState {}

class VerifyOtpSuccess extends StudentAuthState {}

class LoginSuccess extends StudentAuthState {}

class ForgotPasswordSuccess extends StudentAuthState {}

class ValidateOtpSuccess extends StudentAuthState {}

class ResetPasswordSuccess extends StudentAuthState {}

class StudentAuthFailure extends StudentAuthState {
  final String error;

  StudentAuthFailure(this.error);
}