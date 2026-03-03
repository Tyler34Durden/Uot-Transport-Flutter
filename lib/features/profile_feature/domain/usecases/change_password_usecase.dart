import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../repositories/profile_repository.dart';

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repo);
  final ProfileRepository _repo;

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return _repo.changePassword(
      currentPassword: currentPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}

