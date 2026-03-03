import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../entities/auth_register_request.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call(AuthRegisterRequest request) {
    return repository.register(request);
  }
}
