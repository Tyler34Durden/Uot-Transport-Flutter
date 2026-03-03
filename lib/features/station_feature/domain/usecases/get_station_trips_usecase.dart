import 'package:uot_transport/core/usecase/usecase.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_trip_entity.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_trips_repository.dart';

class GetStationTripsUseCase extends UsecaseWithParams<
    List<StationTripEntity>, GetStationTripsParams> {
  const GetStationTripsUseCase(this._repository);

  final StationTripsRepository _repository;

  @override
  ResultFuture<List<StationTripEntity>> call(GetStationTripsParams params) {
    return _repository.getStationTrips(
      stationId: params.stationId,
      token: params.token,
    );
  }
}

class GetStationTripsParams {
  const GetStationTripsParams({
    required this.stationId,
    required this.token,
  });

  final int stationId;
  final String token;
}
