import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetCachedProfileUseCase {
  const GetCachedProfileUseCase(this._repo);
  final ProfileRepository _repo;

  Future<UserProfileEntity?> call() async {
    final cached = await _repo.getCachedUserProfile();
    return cached.fold((_) => null, (p) => p);
  }
}

