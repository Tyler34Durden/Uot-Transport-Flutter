import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  const UserProfileEntity({
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

  @override
  List<Object?> get props => [id, fullName, role, uotNumber, userZone, email, profilePhoto, phone];
}

