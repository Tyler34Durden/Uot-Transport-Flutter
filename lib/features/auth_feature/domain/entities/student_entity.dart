import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final int id;
  final String fullName;
  final String role;
  final String uotNumber;
  final String userZone;
  final String email;
  final String? profilePhoto;
  final String? phone;

  const StudentEntity({
    required this.id,
    required this.fullName,
    required this.role,
    required this.uotNumber,
    required this.userZone,
    required this.email,
    this.profilePhoto,
    this.phone,
  });

  @override
  List<Object?> get props => [id, fullName, role, uotNumber, userZone, email, profilePhoto, phone];
}
