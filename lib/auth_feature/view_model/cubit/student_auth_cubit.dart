//added after rmeoved
import 'package:bloc/bloc.dart';
    import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
    import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

    class StudentAuthCubit extends Cubit<StudentAuthState> {
      final StudentAuthRepository _studentRepository;

      StudentAuthCubit(this._studentRepository) : super(StudentAuthInitial());

      Future<void> registerStudent(Map<String, dynamic> studentData) async {
        emit(StudentAuthLoading());
        try {
          await _studentRepository.registerStudent(studentData);
          emit(RegisterStudentSuccess());
        } catch (e) {
          emit(StudentAuthFailure(e.toString()));
        }
      }

      Future<void> verifyOtp(Map<String, dynamic> otpData) async {
        emit(StudentAuthLoading());
        try {
          await _studentRepository.verifyOtp(otpData);
          emit(VerifyOtpSuccess());
        } catch (e) {
          emit(StudentAuthFailure(e.toString()));
        }
      }

      Future<void> login(Map<String, dynamic> loginData) async {
        emit(StudentAuthLoading());
        try {
          print("before repo data in login");
          await _studentRepository.login(loginData);
          print("after repo data in login");
          emit(LoginSuccess());
        } catch (e) {
          String errorMessage = e is Map && e['message'] != null ? e['message'].toString() : e.toString();
          emit(StudentAuthFailure(errorMessage));
        }
      }

      Future<void> forgotPassword(String email) async {
        emit(StudentAuthLoading());
        try {
          print("before repo data in forgot password");
          await _studentRepository.forgotPassword(email);
          print("after repo data in forgot password");
          emit(ForgotPasswordSuccess());
        } catch (e) {
          emit(StudentAuthFailure(e.toString()));
        }
      }

      Future<void> validateOtp(Map<String, dynamic> otpData) async {
        emit(StudentAuthLoading());
        try {
          await _studentRepository.validateOtp(otpData);
          emit(ValidateOtpSuccess());
        } catch (e) {
          emit(StudentAuthFailure(e.toString()));
        }
      }

      Future<void> resetPassword(Map<String, dynamic> passwordData) async {
        emit(StudentAuthLoading());
        try {
          await _studentRepository.resetPassword(passwordData);
          emit(ResetPasswordSuccess());
        } catch (e) {
          emit(StudentAuthFailure(e.toString()));
        }
      }
    }