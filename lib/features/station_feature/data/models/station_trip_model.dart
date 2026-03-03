import 'package:uot_transport/features/station_feature/domain/entities/station_trip_entity.dart';

class StationTripModel extends StationTripEntity {
  const StationTripModel({
    required super.tripId,
    required super.busId,
    required super.tripState,
    required super.firstTripRoute,
    required super.lastTripRoute,
  });

  factory StationTripModel.fromMap(Map<String, dynamic> map) {
    return StationTripModel(
      tripId: map['tripId']?.toString() ?? '',
      busId: map['busId']?.toString() ?? '',
      tripState: map['tripState']?.toString() ?? 'unknown',
      firstTripRoute: (map['firstTripRoute'] is Map<String, dynamic>)
          ? (map['firstTripRoute'] as Map<String, dynamic>)
          : <String, dynamic>{},
      lastTripRoute: (map['lastTripRoute'] is Map<String, dynamic>)
          ? (map['lastTripRoute'] as Map<String, dynamic>)
          : <String, dynamic>{},
    );
  }
}

