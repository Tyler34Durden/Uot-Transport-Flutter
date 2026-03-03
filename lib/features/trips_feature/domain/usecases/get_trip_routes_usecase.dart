import 'package:uot_transport/core/utilities.dart';

import '../entities/trip_route_entity.dart';
import '../repositories/trips_repository.dart';

class GetTripRoutesUseCase {
  const GetTripRoutesUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<List<TripRouteEntity>> call({
    required String tripId,
    required String token,
  }) {
    return repository.fetchTripRoutes(tripId: tripId, token: token);
  }
}

