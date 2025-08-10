import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
  Future<void> fetchTodayTrips({int? stationId, required String token}) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final trips = await _homeRepository.fetchTodayTrips(stationId: stationId, token: token);
      emit(state.copyWith(trips: trips, isLoading: false, error: null));
    } on DioException catch (e) {
      _logger.e('Error fetching today\'s trips: ${e.message}');
      final errorData = e.response?.data;
      String errorMessage;
      if (errorData is Map && errorData['message'] != null) {
        errorMessage = errorData['message'].toString();
      } else {
        errorMessage = e.toString();
      }
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Fetch stations
  Future<void> fetchStations(String token) async {
    if (state.stations.isNotEmpty) return;
    try {
      emit(state.copyWith(isLoading: true));
      final stations = await _homeRepository.fetchStations(token);
      emit(state.copyWith(stations: stations, isLoading: false));
    }  on DioException catch (e) {
      _logger.e('Error fetching stations: ${e.message}');
      final errorData = e.response?.data;
      String errorMessage;
      if (errorData is Map && errorData['message'] != null) {
        errorMessage = errorData['message'].toString();
      } else {
        errorMessage = e.toString();
      }
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> fetchMyTrips(String token) async {
    try {
      emit(state.copyWith(isFetchMyTripsLoading: true, fetchMyTripsError: null));
      final myTrips = await _homeRepository.fetchMyTrips(token);
      emit(state.copyWith(
        myTrips: myTrips,
        isFetchMyTripsLoading: false,
        fetchMyTripsError: null,
      ));
    } on DioException catch (e) {
      _logger.e('Error fetching my trips: ${e.message}');
      final errorData = e.response?.data;
      String errorMessage;
      if (errorData is Map && errorData['message'] != null) {
        errorMessage = errorData['message'].toString();
      } else {
        errorMessage = e.toString();
      }
      emit(state.copyWith(
        isFetchMyTripsLoading: false,
        fetchMyTripsError: e.toString(),
      ));
    }
  }
}