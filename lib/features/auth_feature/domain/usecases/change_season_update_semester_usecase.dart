import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';

import '../repositories/change_season_repository.dart';

class ChangeSeasonUpdateSemesterUseCase {
  final ChangeSeasonRepository repository;

  const ChangeSeasonUpdateSemesterUseCase(this.repository);

  Future<Either<Failure, void>> call(ChangeSeasonUpdateRequest request) {
    return repository.updateSemester(request);
  }
}
