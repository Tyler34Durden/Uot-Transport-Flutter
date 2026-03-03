import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/student_entity.dart';
import '../entities/auth_login_request.dart';
import 'package:uot_transport/core/error/failures.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, StudentEntity>> call(AuthLoginRequest request) {
    return repository.login(request);
  }
}
