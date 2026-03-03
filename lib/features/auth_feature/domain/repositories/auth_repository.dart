import 'package:uot_transport/core/utilities.dart';

import '../entities/auth_login_request.dart';
import '../entities/auth_register_request.dart';
import '../entities/otp_request.dart';
import '../entities/reset_password_request.dart';
import '../entities/student_entity.dart';

abstract class AuthRepository {
  ResultFuture<StudentEntity> login(AuthLoginRequest request);
  ResultVoid register(AuthRegisterRequest request);
  ResultVoid verifyOtp(OtpRequest request);
  ResultVoid forgotPassword(String email);
  ResultVoid validateOtp(OtpRequest request);
  ResultVoid resetPassword(ResetPasswordRequest request);
}
