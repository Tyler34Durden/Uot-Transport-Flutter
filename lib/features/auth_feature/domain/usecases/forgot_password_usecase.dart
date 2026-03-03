import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import 'package:uot_transport/core/error/failures.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) {
    return repository.forgotPassword(email);
  }
}
