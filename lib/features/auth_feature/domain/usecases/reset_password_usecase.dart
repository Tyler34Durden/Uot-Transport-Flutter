import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../entities/reset_password_request.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordRequest request) {
    return repository.resetPassword(request);
  }
}
