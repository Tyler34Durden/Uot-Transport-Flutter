import 'package:uot_transport/features/station_feature/data/models/station_trip_model.dart';

abstract class StationTripsRemoteDataSource {
  Future<List<StationTripModel>> getStationTrips({
    required int stationId,
    required String token,
  });
}

