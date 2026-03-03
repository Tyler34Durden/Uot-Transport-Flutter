import '../../domain/entities/home_trip_entity.dart';

class HomeTripModel extends HomeTripEntity {
  const HomeTripModel({
    required super.tripId,
    required super.busId,
    required super.tripState,
    required super.firstTripRoute,
    required super.lastTripRoute,
  });

  factory HomeTripModel.fromJson(Map<String, dynamic> json) => HomeTripModel(
        tripId: (json['tripId'] ?? '').toString(),
        busId: (json['busId'] ?? '').toString(),
        tripState: json['tripState'],
        firstTripRoute: (json['firstTripRoute'] is Map<String, dynamic>)
            ? (json['firstTripRoute'] as Map<String, dynamic>)
            : <String, dynamic>{},
        lastTripRoute: (json['lastTripRoute'] is Map<String, dynamic>)
            ? (json['lastTripRoute'] as Map<String, dynamic>)
            : <String, dynamic>{},
      );
}

