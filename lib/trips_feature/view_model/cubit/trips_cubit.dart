import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/trips_feature/model/repository/trips_repository.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  final Logger _logger = Logger();

  TripsCubit(this._tripsRepository) : super(TripsInitial());

 // Future<void> fetchTrips() async {
  //   _logger.i('Fetching all trips');
  //   emit(TripsLoading());
  //   try {
  //     final response = await _tripsRepository.fetchTrips();
  //     emit(TripsLoaded(response));
  //   } catch (e) {
  //     _logger.e('Error while fetching trips: $e');
  //     emit(TripsError(e.toString()));
  //   }
  // }



  Future<void> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
  }) async {
    emit(TripsLoading());
    try {
      final trips = await _tripsRepository.fetchTripsByStations(
        startStationId: startStationId,
        endStationId: endStationId,
      );
      emit(TripsLoaded(trips));
    } catch (e) {
      _logger.e('Error while fetching trips: $e');
      emit(TripsError(e.toString()));
    }
  }
}