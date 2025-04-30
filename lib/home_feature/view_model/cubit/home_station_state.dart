
part of 'home_station_cubit.dart';

@immutable
class HomeStationState {
  final List<Map<String, dynamic>> stations;
  final List<dynamic> trips;
  final bool isLoading;
  final String? error;

  const HomeStationState({
    this.stations = const [],
    this.trips = const [],
    this.isLoading = false,
    this.error,
  });

  HomeStationState copyWith({
    List<Map<String, dynamic>>? stations,
    List<dynamic>? trips,
    bool? isLoading,
    String? error,
  }) {
    return HomeStationState(
      stations: stations ?? this.stations,
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}