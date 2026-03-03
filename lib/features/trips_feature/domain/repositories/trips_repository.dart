import 'package:uot_transport/core/utilities.dart';

import '../entities/trip_entity.dart';
import '../entities/trip_route_entity.dart';
import '../entities/ticket_request.dart';

abstract class TripsRepository {
  ResultFuture<List<TripEntity>> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
    int page = 1,
    int pageSize = 5,
    required String token,
  });

  ResultFuture<List<TripRouteEntity>> fetchTripRoutes({
    required String tripId,
    required String token,
  });

  ResultFuture<Map<String, dynamic>> fetchTripDetails({
    required String tripId,
    required String token,
  });

  ResultFuture<void> createTicket({
    required TicketRequest request,
    required String token,
  });

  ResultFuture<void> cancelTicket({
    required int tripId,
    required String token,
  });

  ResultFuture<void> updateTicketState({
    required int tripRouteId,
    required String token,
  });
}

