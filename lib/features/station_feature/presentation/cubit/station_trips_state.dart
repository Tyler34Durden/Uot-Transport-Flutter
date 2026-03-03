import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_trip_entity.dart';

part 'station_trips_state.freezed.dart';

@freezed
class StationTripsState with _$StationTripsState {
  const factory StationTripsState.initial() = _StationTripsInitial;
  const factory StationTripsState.loading() = _StationTripsLoading;
  const factory StationTripsState.loaded({required List<StationTripEntity> trips}) = _StationTripsLoaded;
  const factory StationTripsState.failure({required Failure failure}) = _StationTripsFailure;
}
