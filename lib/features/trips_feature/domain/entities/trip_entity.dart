import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  const TripEntity({
    required this.tripId,
    required this.busId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  final String tripId;
  final String busId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  @override
  List<Object?> get props => [tripId, busId, tripState, firstTripRoute, lastTripRoute];
}

