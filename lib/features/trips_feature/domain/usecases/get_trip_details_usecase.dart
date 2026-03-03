import 'package:uot_transport/core/utilities.dart';

import '../repositories/trips_repository.dart';

class GetTripDetailsUseCase {
  const GetTripDetailsUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<Map<String, dynamic>> call({
    required String tripId,
    required String token,
  }) {
    return repository.fetchTripDetails(tripId: tripId, token: token);
  }
}

