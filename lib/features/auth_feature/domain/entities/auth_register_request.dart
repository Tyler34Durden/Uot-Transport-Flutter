class AuthRegisterRequest {
  const AuthRegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.uotNumber,
    required this.userZone,
    required this.gender,
    required this.qrData,
  });

  final String fullName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String uotNumber;
  final String userZone;
  final String gender;
  final String qrData;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'uotNumber': uotNumber,
        'userZone': userZone,
        'gender': gender,
        'qrData': qrData,
      };
}

