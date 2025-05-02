//aded
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/station_feature/model/repository/station_trips_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_state.dart';

class StationTripsCubit extends Cubit<StationTripsState> {
  final StationTripsRepository _repository;
  final Logger _logger = Logger();

  StationTripsCubit(this._repository) : super(StationTripsInitial());

  Future<void> fetchStationTrips(int stationId) async {
    _logger.i('Fetching station trips for stationId: $stationId');
    emit(StationTripsLoading());
    try {
      final response = await _repository.fetchStationTrips(stationId);
      final data = response.data;
      if (data is List) {
        _logger.i('Parsed station trips with ${data.length} items');
        emit(StationTripsSuccess(data));
      } else {
        _logger.i('Parsed single station trip, converting to list');
        emit(StationTripsSuccess([data]));
      }
    } catch (e) {
      _logger.e('Error while fetching station trips: $e');
      emit(StationTripsFailure(e.toString()));
    }
  }
}