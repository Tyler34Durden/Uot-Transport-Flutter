import 'package:uot_transport/core/utilities.dart';

import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class GetTripsByStationsUseCase {
  const GetTripsByStationsUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<List<TripEntity>> call({
    String? startStationId,
    String? endStationId,
    int page = 1,
    int pageSize = 5,
    required String token,
  }) {
    return repository.fetchTripsByStations(
      startStationId: startStationId,
      endStationId: endStationId,
      page: page,
      pageSize: pageSize,
      token: token,
    );
  }
}

