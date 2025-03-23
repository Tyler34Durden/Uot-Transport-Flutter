// File: lib/auth_feature/view_model/cubit/student_cubit.dart
    import 'package:bloc/bloc.dart';
    import 'package:uot_transport/auth_feature/model/repository/student_repository.dart';
    import 'package:uot_transport/auth_feature/view_model/cubit/student_state.dart';

    class StudentCubit extends Cubit<StudentState> {
      final StudentRepository _studentRepository;

      StudentCubit(this._studentRepository) : super(StudentInitial());

      Future<void> registerStudent(Map<String, dynamic> studentData) async {
        emit(StudentLoading());
        try {
          await _studentRepository.registerStudent(studentData);
          emit(StudentSuccess());
        } catch (e) {
          emit(StudentFailure(e.toString()));
        }
      }

      Future<void> verifyOtp(Map<String, dynamic> otpData) async {
        emit(StudentLoading());
        try {
          await _studentRepository.verifyOtp(otpData);
          emit(StudentSuccess());
        } catch (e) {
          emit(StudentFailure(e.toString()));
        }
      }

  Future<void> login(Map<String, dynamic> loginData) async {
    emit(StudentLoading());
    try {
      print("before repo data in login");
      await _studentRepository.login(loginData);
      print("after repo data in login");
      emit(StudentSuccess());
    } catch (e) {
      emit(StudentFailure(e.toString()));
    }
  }



    }