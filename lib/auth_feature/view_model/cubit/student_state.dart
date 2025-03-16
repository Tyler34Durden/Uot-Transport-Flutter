class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {}

class StudentFailure extends StudentState {
  final String error;

  StudentFailure(this.error);
}