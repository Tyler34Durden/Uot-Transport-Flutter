import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  final StationsRepository _stationsRepository;
  final Logger _logger = Logger();

  StationsCubit(this._stationsRepository) : super(StationsInitial());

  Future<void> fetchStations({bool? near}) async {
    _logger.i('Fetching all stations with near filter: $near');
    emit(StationsLoading());
    try {
      final response = await _stationsRepository.fetchStations();
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
          _logger.i('After filtering, stations: ${stations.length} items');
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

  Future<void> fetchFilteredStations(bool inUot) async {
    _logger.i('Fetching filtered stations for inUot value: $inUot');
    emit(StationsLoading());
    try {
      final response = await _stationsRepository.fetchFilteredStations(inUot);
      _logger.i('Filtered response received: ${response.data}');
      final data = response.data;
      if (data is Map &&
          data.containsKey('data') &&
          data['data'] is List<dynamic>) {
        final stations = data['data'] as List<dynamic>;
        _logger.i('Parsed filtered stations from Map: ${stations.length} items');
        emit(StationsSuccess(stations));
      } else if (data is List) {
        final stations = data as List<dynamic>;
        _logger.i('Parsed filtered stations from List: ${stations.length} items');
        emit(StationsSuccess(stations));
      } else {
        _logger.e('Invalid data format in filtered stations response: $data');
        throw Exception('Invalid data format in filtered stations response');
      }
    } catch (e) {
      _logger.e('Error while fetching filtered stations: $e');
      emit(StationsFailure(e.toString()));
    }
  }

  // دالة البحث عن المحطات بواسطة اسم المحطة
  Future<void> searchStations(String stationName) async {
    _logger.i('Searching stations with name: $stationName');
    emit(StationsLoading());
    try {
      final response = await _stationsRepository.searchStations(stationName);
      _logger.i('Search response received: ${response.data}');
      final data = response.data;
      // تعامل مع الشكل نفسه كما في باقي الدوال
      if (data is Map &&
          data.containsKey('data') &&
          data['data'] is List<dynamic>) {
        final stations = data['data'] as List<dynamic>;
        _logger.i('Parsed search stations: ${stations.length} items');
        emit(StationsSuccess(stations));
      } else if (data is List) {
        final stations = data as List<dynamic>;
        _logger.i('Parsed search stations from List: ${stations.length} items');
        emit(StationsSuccess(stations));
      } else {
        _logger.e('Invalid data format in search stations response: $data');
        throw Exception('Invalid data format in search stations response');
      }
    } catch (e) {
      _logger.e('Error while searching stations: $e');
      emit(StationsFailure(e.toString()));
    }
  }
}