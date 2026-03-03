import 'package:uot_transport/core/utilities.dart';

import '../entities/advertising_entity.dart';
import '../entities/home_trip_entity.dart';
import '../../../station_feature/domain/entities/station_entity.dart';

abstract class HomeRepository {
  ResultFuture<List<AdvertisingEntity>> getAdvertisings({required String token});

  ResultFuture<List<StationEntity>> getStations({required String token});

  ResultFuture<List<HomeTripEntity>> getMyTrips({required String token});

  ResultFuture<List<HomeTripEntity>> getTodayTrips({
    int? stationId,
    required String token,
  });
}

