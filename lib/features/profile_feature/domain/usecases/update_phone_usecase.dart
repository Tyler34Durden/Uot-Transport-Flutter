import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdatePhoneUseCase {
  const UpdatePhoneUseCase(this._repo);
  final ProfileRepository _repo;

  Future<Either<Failure, UserProfileEntity>> call(String phone) {
    return _repo.updateUserPhone(phone: phone);
  }
}

