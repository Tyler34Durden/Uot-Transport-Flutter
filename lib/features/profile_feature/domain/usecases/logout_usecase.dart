import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../repositories/profile_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repo);
  final ProfileRepository _repo;

  Future<Either<Failure, void>> call() {
    return _repo.logout();
  }

  Future<void> clearSession() async {
    await _repo.clearSession();
  }
}

