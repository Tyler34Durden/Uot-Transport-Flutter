import '../../domain/entities/student_entity.dart';

class StudentModel {
  const StudentModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.uotNumber,
    required this.userZone,
    required this.email,
    this.profilePhoto,
    this.phone,
  });

  final int id;
  final String fullName;
  final String role;
  final String uotNumber;
  final String userZone;
  final String email;
  final String? profilePhoto;
  final String? phone;

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        fullName: (json['fullName'] ?? '').toString(),
        role: (json['role'] ?? '').toString(),
        uotNumber: (json['uotNumber'] ?? '').toString(),
        userZone: (json['userZone'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        profilePhoto: json['profilePhoto']?.toString(),
        phone: json['phone']?.toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'fullName': fullName,
        'role': role,
        'uotNumber': uotNumber,
        'userZone': userZone,
        'email': email,
        'profilePhoto': profilePhoto,
        'phone': phone,
      };

  StudentEntity toEntity() => StudentEntity(
        id: id,
        fullName: fullName,
        role: role,
        uotNumber: uotNumber,
        userZone: userZone,
        email: email,
        profilePhoto: profilePhoto,
        phone: phone,
      );
}
