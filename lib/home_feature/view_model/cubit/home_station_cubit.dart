
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';

part 'home_station_state.dart';

class HomeStationCubit extends Cubit<HomeStationState> {
  final HomeRepository _homeRepository;
  final _logger = Logger();

  HomeStationCubit(this._homeRepository)
      : super(HomeStationState());

  // Fetch today's trips
  Future<void> fetchTodayTrips({int? stationId}) async {
    try {
      emit(state.copyWith(isLoading: true));
      final trips = await _homeRepository.fetchTodayTrips(stationId: stationId);
      emit(state.copyWith(trips: trips, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // Fetch stations
  Future<void> fetchStations() async {
    if (state.stations.isNotEmpty) return;
    try {
      emit(state.copyWith(isLoading: true));
      final stations = await _homeRepository.fetchStations();
      emit(state.copyWith(stations: stations, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
