//added after removed
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic> profile;
  ProfileSuccess(this.profile);
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error);
}