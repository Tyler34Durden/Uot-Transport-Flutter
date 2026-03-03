import '../../domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.tripId,
    required super.busId,
    required super.tripState,
    required super.firstTripRoute,
    required super.lastTripRoute,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        tripId: (json['tripId'] ?? '').toString(),
        busId: (json['busId'] ?? '').toString(),
        tripState: (json['tripState'] ?? '').toString(),
        firstTripRoute: (json['firstTripRoute'] is Map<String, dynamic>)
            ? (json['firstTripRoute'] as Map<String, dynamic>)
            : <String, dynamic>{},
        lastTripRoute: (json['lastTripRoute'] is Map<String, dynamic>)
            ? (json['lastTripRoute'] as Map<String, dynamic>)
            : <String, dynamic>{},
      );
}

