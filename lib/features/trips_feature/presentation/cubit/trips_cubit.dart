import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ticket_request.dart';
import '../../domain/usecases/cancel_ticket_usecase.dart';
import '../../domain/usecases/create_ticket_usecase.dart';
import '../../domain/usecases/get_trip_details_usecase.dart';
import '../../domain/usecases/get_trip_routes_usecase.dart';
import '../../domain/usecases/get_trips_by_stations_usecase.dart';
import '../../domain/usecases/update_ticket_state_usecase.dart';
import 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit({
    required GetTripsByStationsUseCase getTripsByStations,
    required GetTripRoutesUseCase getTripRoutes,
    required GetTripDetailsUseCase getTripDetails,
    required CreateTicketUseCase createTicket,
    required CancelTicketUseCase cancelTicket,
    required UpdateTicketStateUseCase updateTicketState,
  })  : _getTripsByStations = getTripsByStations,
        _getTripRoutes = getTripRoutes,
        _getTripDetails = getTripDetails,
        _createTicket = createTicket,
        _cancelTicket = cancelTicket,
        _updateTicketState = updateTicketState,
        super(const TripsState.initial());

  final GetTripsByStationsUseCase _getTripsByStations;
  final GetTripRoutesUseCase _getTripRoutes;
  final GetTripDetailsUseCase _getTripDetails;
  final CreateTicketUseCase _createTicket;
  final CancelTicketUseCase _cancelTicket;
  final UpdateTicketStateUseCase _updateTicketState;

  int _page = 1;
  final int _pageSize = 5;
  bool _hasMore = true;
  final List trips = [];

  Future<void> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
    bool loadMore = false,
    required String token,
  }) async {
    if (!loadMore) {
      _page = 1;
      trips.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;

    emit(TripsState.tripsLoading(isLoadMore: loadMore));

    final result = await _getTripsByStations(
      startStationId: startStationId,
      endStationId: endStationId,
      page: _page,
      pageSize: _pageSize,
      token: token,
    );

    result.fold(
      (failure) => emit(TripsState.tripsFailure(message: failure.message)),
      (newTrips) {
        if (newTrips.length < _pageSize) _hasMore = false;
        trips.addAll(newTrips);
        emit(
          TripsState.tripsLoaded(
            trips: List.unmodifiable(trips.cast()),
            hasMore: _hasMore,
            page: _page,
          ),
        );
        _page++;
      },
    );
  }

  Future<void> fetchTripRoutes({required String tripId, required String token}) async {
    emit(const TripsState.routesLoading());
    final result = await _getTripRoutes(tripId: tripId, token: token);
    result.fold(
      (failure) => emit(TripsState.routesFailure(message: failure.message)),
      (routes) => emit(TripsState.routesLoaded(routes: routes)),
    );
  }

  Future<void> createTicket({required TicketRequest request, required String token}) async {
    emit(const TripsState.ticketActionLoading());
    final result = await _createTicket(request: request, token: token);
    result.fold(
      (failure) => emit(TripsState.ticketActionFailure(message: failure.message)),
      (_) => emit(const TripsState.ticketActionSuccess(message: 'Ticket created successfully')),
    );
  }

  Future<void> cancelTicket({required int tripId, required String token}) async {
    emit(const TripsState.ticketActionLoading());
    final result = await _cancelTicket(tripId: tripId, token: token);
    result.fold(
      (failure) => emit(TripsState.ticketActionFailure(message: failure.message)),
      (_) => emit(const TripsState.ticketActionSuccess(message: 'Ticket cancelled successfully')),
    );
  }

  Future<void> updateTicketState({required int tripRouteId, required String token}) async {
    emit(const TripsState.ticketActionLoading());
    final result = await _updateTicketState(tripRouteId: tripRouteId, token: token);
    result.fold(
      (failure) => emit(TripsState.ticketActionFailure(message: failure.message)),
      (_) => emit(const TripsState.ticketActionSuccess(message: 'Ticket state updated successfully')),
    );
  }

  Future<void> fetchTripDetails({required String tripId, required String token}) async {
    emit(const TripsState.detailsLoading());
    final result = await _getTripDetails(tripId: tripId, token: token);
    result.fold(
      (failure) => emit(TripsState.detailsFailure(message: failure.message)),
      (details) => emit(TripsState.detailsLoaded(details: details)),
    );
  }
}
