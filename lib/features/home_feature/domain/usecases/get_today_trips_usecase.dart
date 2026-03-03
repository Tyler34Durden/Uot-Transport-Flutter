import 'package:uot_transport/core/utilities.dart';

import '../entities/home_trip_entity.dart';
import '../repositories/home_repository.dart';

class GetTodayTripsUseCase {
  const GetTodayTripsUseCase(this.repository);
  final HomeRepository repository;

  ResultFuture<List<HomeTripEntity>> call({int? stationId, required String token}) {
    return repository.getTodayTrips(stationId: stationId, token: token);
  }
}

