class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.otp,
  });

  final String email;
  final String password;
  final String passwordConfirmation;
  final String otp;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'otp': otp,
      };
}

