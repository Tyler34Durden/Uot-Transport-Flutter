import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_trip_entity.dart';

abstract class StationTripsRepository {
  ResultFuture<List<StationTripEntity>> getStationTrips({
    required int stationId,
    required String token,
  });
}

