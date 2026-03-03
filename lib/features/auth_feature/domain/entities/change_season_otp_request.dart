class ChangeSeasonOtpRequest {
  const ChangeSeasonOtpRequest({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'otp': otp,
      };
}

