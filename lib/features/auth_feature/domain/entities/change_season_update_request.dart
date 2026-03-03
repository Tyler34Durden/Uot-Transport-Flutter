class ChangeSeasonUpdateRequest {
  const ChangeSeasonUpdateRequest({
    required this.email,
    required this.otp,
    required this.qrData,
  });

  final String email;
  final String otp;
  final String qrData;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'otp': otp,
        'qrData': qrData,
      };
}
