import '../../data/models/student_model.dart';

class AuthLoginResponse {
  const AuthLoginResponse({
    required this.user,
    required this.token,
  });

  final StudentModel user;
  final String token;

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AuthLoginResponse(
      user: userJson is Map<String, dynamic>
          ? StudentModel.fromJson(userJson)
          : const StudentModel(
              id: 0,
              fullName: '',
              role: '',
              uotNumber: '',
              userZone: '',
              email: '',
            ),
      token: (json['token'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user.toJson(),
        'token': token,
      };
}

