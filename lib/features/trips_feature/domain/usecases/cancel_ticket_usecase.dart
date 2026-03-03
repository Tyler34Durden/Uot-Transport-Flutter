import 'package:uot_transport/core/utilities.dart';

import '../repositories/trips_repository.dart';

class CancelTicketUseCase {
  const CancelTicketUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<void> call({
    required int tripId,
    required String token,
  }) {
    return repository.cancelTicket(tripId: tripId, token: token);
  }
}

