import 'package:uot_transport/core/utilities.dart';

import '../repositories/trips_repository.dart';

class UpdateTicketStateUseCase {
  const UpdateTicketStateUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<void> call({
    required int tripRouteId,
    required String token,
  }) {
    return repository.updateTicketState(tripRouteId: tripRouteId, token: token);
  }
}

