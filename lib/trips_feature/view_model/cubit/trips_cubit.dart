import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/trips_feature/model/repository/trips_repository.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  final Logger _logger = Logger();

  int _currentPage = 1;
  final int _pageSize = 5;
  bool _hasMore = true;
  List<dynamic> _trips = [];

  TripsCubit(this._tripsRepository) : super(TripsInitial());

  Future<void> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
    bool loadMore = false,
    required String token
  }) async {
    if (!loadMore) {
      _currentPage = 1;
      _trips.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;

    emit(TripsLoading());
    try {
      final trips = await _tripsRepository.fetchTripsByStations(
        startStationId: startStationId,
        endStationId: endStationId,
        page: _currentPage,
        pageSize: _pageSize,
        token: token
      );
      final newTrips = trips as List<dynamic>;
      if (newTrips.length < _pageSize) _hasMore = false;
      _trips.addAll(newTrips);
      emit(TripsLoaded(_trips));
      _currentPage++;
    } catch (e) {
      _logger.e('Error while fetching trips: $e');
      emit(TripsError(e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString()));
    }
  }

  Future<void> fetchTripDetailsScreen(String tripID,String token) async {
    emit(TripDetailsLoading());
    try {
      final tripDetails = await _tripsRepository.fetchTripDetailsScreen(tripID, token);
      emit(TripDetailsLoaded(tripDetails));
    } catch (e) {
      _logger.e('Error while fetching trip details from API: $e');
      emit(TripDetailsError(e.toString()));
    }
  }

  Future<void> fetchTripRoutes(String tripID,String token) async {
    emit(TripRoutesLoading());
    try {
      print("entered the try method in the fetch trips by route");
      final tripRoutes = await _tripsRepository.fetchTripRoutes(tripID,token);
      print("before the emit in the fetch trips by route");
      emit(TripRoutesLoaded(tripRoutes));
    } catch (e) {
      _logger.e('Error while fetching trip routes: $e');
      emit(TripRoutesError(e.toString()));
    }
  }
Future<void> createTicket({
    required int tripID,
    required int fromTripRoute,
    required int toTripRoute,
    required String token,
  }) async {
    emit(TripsTicketLoading());
    try {
      await _tripsRepository.createTicket(
        tripID: tripID,
        fromTripRoute: fromTripRoute,
        toTripRoute: toTripRoute,
        token: token,
      );
      emit(TripsTicketSuccess('Ticket created successfully'));
    } catch (e) {
      _logger.e('Error while creating ticket: $e');
      emit(TripsTicketError(e.toString()));
    }
  }
  Future<void> cancelTicket({
    required int tripId,
    required String token,
  }) async {
    emit(TripsTicketLoading());
    try {
      await _tripsRepository.cancelTicket(
        tripId: tripId,
        token: token,
      );
      emit(TripsTicketSuccess('Ticket cancelled successfully'));
    } catch (e) {
      _logger.e('Error while cancelling ticket: $e');
      emit(TripCancelError(e.toString()));
    }
  }


  Future<void> updateTicketState({
    required int tripRouteId,
    required String token,
  }) async {
    emit(TripsTicketLoading());
    try {
      await _tripsRepository.updateTicketState(
        tripRouteId: tripRouteId,
        token: token,
      );
      emit(TripsTicketSuccess('Ticket state updated successfully'));
    } catch (e) {
      _logger.e('Error while updating ticket state: $e');
      emit(TripsTicketError(e.toString()));
    }
  }
}