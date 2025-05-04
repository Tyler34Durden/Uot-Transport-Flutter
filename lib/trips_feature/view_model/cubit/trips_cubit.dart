import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/trips_feature/model/repository/trips_repository.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  final Logger _logger = Logger();

  TripsCubit(this._tripsRepository) : super(TripsInitial());

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

  Future<void> fetchTripRoutes(String tripID) async {
    emit(TripRoutesLoading());
    try {
      print("entered the try method in the fetch trips by route");
      final tripRoutes = await _tripsRepository.fetchTripRoutes(tripID);
      print("before the emit in the fetch trips by route");
      emit(TripRoutesLoaded(tripRoutes));
    } catch (e) {
      _logger.e('Error while fetching trip routes: $e');
      emit(TripRoutesError(e.toString()));
    }
  }
}