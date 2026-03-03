import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../repositories/change_season_repository.dart';
import '../entities/change_season_send_request.dart';

class ChangeSeasonSendOtpUseCase {
  final ChangeSeasonRepository repository;

  const ChangeSeasonSendOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(ChangeSeasonSendRequest request) {
    return repository.sendOtp(request);
  }
}

