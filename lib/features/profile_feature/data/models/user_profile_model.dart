import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
  const UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
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

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        fullName: fullName,
        role: role,
        uotNumber: uotNumber,
        userZone: userZone,
        email: email,
        profilePhoto: profilePhoto,
        phone: phone,
      );

  factory UserProfileModel.fromEntity(UserProfileEntity entity) => UserProfileModel(
        id: entity.id,
        fullName: entity.fullName,
        role: entity.role,
        uotNumber: entity.uotNumber,
        userZone: entity.userZone,
        email: entity.email,
        profilePhoto: entity.profilePhoto,
        phone: entity.phone,
      );
}

