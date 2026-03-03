import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../entities/otp_request.dart';
import '../repositories/auth_repository.dart';

class ValidateOtpUseCase {
  final AuthRepository repository;
  ValidateOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(OtpRequest request) {
    return repository.validateOtp(request);
  }
}
