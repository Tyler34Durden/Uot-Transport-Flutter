import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../entities/user_profile_entity.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;

abstract class ProfileRepository {
  ResultFuture<String?> getToken();
  ResultFuture<UserProfileEntity?> getCachedUserProfile();

  ResultFuture<UserProfileEntity> fetchUserProfile({required int userId});
  ResultFuture<UserProfileEntity> updateUserPhone({required String phone});

  ResultVoid changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });

  ResultVoid logout();

  ResultVoid clearSession();
}

