import 'package:equatable/equatable.dart';

/// Minimal trip entity for the Home screen needs.
///
/// This mirrors what legacy Home UI reads from the API maps.
class HomeTripEntity extends Equatable {
  const HomeTripEntity({
    required this.tripId,
    required this.busId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  final String tripId;
  final String busId;
  final dynamic tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  @override
  List<Object?> get props => [tripId, busId, tripState, firstTripRoute, lastTripRoute];
}

