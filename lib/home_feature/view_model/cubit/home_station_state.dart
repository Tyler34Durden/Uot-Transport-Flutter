part of 'home_station_cubit.dart';

    @immutable
    class HomeStationState {
      final List<Map<String, dynamic>> stations;
      final List<dynamic> trips;
      final bool isLoading;
      final String? error;

      // New properties for FetchMyTrips states
      final bool isFetchMyTripsLoading;
      final String? fetchMyTripsError;
      final List<dynamic> myTrips;

      const HomeStationState({
        this.stations = const [],
        this.trips = const [],
        this.isLoading = false,
        this.error,
        this.isFetchMyTripsLoading = false,
        this.fetchMyTripsError,
        this.myTrips = const [],
      });

      HomeStationState copyWith({
        List<Map<String, dynamic>>? stations,
        List<dynamic>? trips,
        bool? isLoading,
        String? error,
        bool? isFetchMyTripsLoading,
        String? fetchMyTripsError,
        List<dynamic>? myTrips,
      }) {
        return HomeStationState(
          stations: stations ?? this.stations,
          trips: trips ?? this.trips,
          isLoading: isLoading ?? this.isLoading,
          error: error,
          isFetchMyTripsLoading: isFetchMyTripsLoading ?? this.isFetchMyTripsLoading,
          fetchMyTripsError: fetchMyTripsError,
          myTrips: myTrips ?? this.myTrips,
        );
      }
    }