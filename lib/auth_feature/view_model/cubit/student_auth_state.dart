//added after removed
class StudentAuthState {}

class StudentAuthInitial extends StudentAuthState {}

class StudentAuthLoading extends StudentAuthState {}

class StudentAuthSuccess extends StudentAuthState {}

class StudentAuthFailure extends StudentAuthState {
  final String error;

  StudentAuthFailure(this.error);
}