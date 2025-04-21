import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  final StationsRepository _stationsRepository;
  final Logger _logger = Logger();

  StationsCubit(this._stationsRepository) : super(StationsInitial());

  // دالة جلب المحطات باستخدام المعاملات inUOT و search مع خيار للفلترة بواسطة near
  Future<void> fetchStations({String? inUOT, String? search, bool? near}) async {
    _logger.i('Fetching stations with parameters: inUOT=$inUOT, search=$search, near filter: $near');
    emit(StationsLoading());
    try {
      final response = await _stationsRepository.fetchStations(inUOT: inUOT, search: search);
      _logger.i('Response received: ${response.data}');
      if (response.data is Map &&
          response.data.containsKey('data') &&
          response.data['data'] is List<dynamic>) {
        var stations = response.data['data'] as List<dynamic>;
        _logger.i('Parsed stations: ${stations.length} items');
        if (near != null) {
          stations = stations.where((item) {
            final nt = item['nearestTrip'];
            return near ? (nt != null) : (nt == null);
          }).toList();
          _logger.i('After filtering, stations count: ${stations.length}');
        }
        emit(StationsSuccess(stations));
      } else {
        _logger.e('Invalid data format in stations response: ${response.data}');
        throw Exception('Invalid data format in stations response');
      }
    } catch (e) {
      _logger.e('Error while fetching stations: $e');
      emit(StationsFailure(e.toString()));
    }
  }

  // دالة البحث عن المحطات باستخدام قيمة البحث
  Future<void> searchStations(String stationName) async {
    _logger.i('Searching stations with name: $stationName');
    emit(StationsLoading());
    try {
      final response = await _stationsRepository.fetchStations(search: stationName);
      _logger.i('Search response received: ${response.data}');
      if (response.data is Map &&
          response.data.containsKey('data') &&
          response.data['data'] is List<dynamic>) {
        final stations = response.data['data'] as List<dynamic>;
        _logger.i('Parsed search stations count: ${stations.length}');
        emit(StationsSuccess(stations));
      } else {
        _logger.e('Invalid data format in search stations response: ${response.data}');
        throw Exception('Invalid data format in search stations response');
      }
    } catch (e) {
      _logger.e('Error while searching stations: $e');
      emit(StationsFailure(e.toString()));
    }
  }
}