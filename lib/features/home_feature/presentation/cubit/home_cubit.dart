import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/advertising_entity.dart';
import '../../domain/entities/home_trip_entity.dart';
import '../../domain/usecases/get_advertisings_usecase.dart';
import '../../domain/usecases/get_home_stations_usecase.dart';
import '../../domain/usecases/get_my_trips_usecase.dart';
import '../../domain/usecases/get_today_trips_usecase.dart';
import '../../../station_feature/domain/entities/station_entity.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetAdvertisingsUseCase getAdvertisings,
    required GetHomeStationsUseCase getStations,
    required GetMyTripsUseCase getMyTrips,
    required GetTodayTripsUseCase getTodayTrips,
  })  : _getAdvertisings = getAdvertisings,
        _getStations = getStations,
        _getMyTrips = getMyTrips,
        _getTodayTrips = getTodayTrips,
        super(const HomeState.initial());

  final GetAdvertisingsUseCase _getAdvertisings;
  final GetHomeStationsUseCase _getStations;
  final GetMyTripsUseCase _getMyTrips;
  final GetTodayTripsUseCase _getTodayTrips;

  Future<void> loadInitial({required String token}) async {
    final currentAds = state.maybeWhen(
      loading: (ads, _, __, ___) => ads,
      loaded: (ads, _, __, ___) => ads,
      failure: (_, ads, __, ___, ____) => ads,
      orElse: () => const <AdvertisingEntity>[],
    );
    final currentStations = state.maybeWhen(
      loading: (_, stations, __, ___) => stations,
      loaded: (_, stations, __, ___) => stations,
      failure: (_, __, stations, ___, ____) => stations,
      orElse: () => const <StationEntity>[],
    );
    final currentMyTrips = state.maybeWhen(
      loading: (_, __, myTrips, ___) => myTrips,
      loaded: (_, __, myTrips, ___) => myTrips,
      failure: (_, __, ___, myTrips, ____) => myTrips,
      orElse: () => const <HomeTripEntity>[],
    );
    final currentTodayTrips = state.maybeWhen(
      loading: (_, __, ___, todayTrips) => todayTrips,
      loaded: (_, __, ___, todayTrips) => todayTrips,
      failure: (_, __, ___, ____, todayTrips) => todayTrips,
      orElse: () => const <HomeTripEntity>[],
    );

    emit(HomeState.loading(
      advertisings: currentAds,
      stations: currentStations,
      myTrips: currentMyTrips,
      todayTrips: currentTodayTrips,
    ));

    final advertisingsResult = await _getAdvertisings(token: token);
    final stationsResult = await _getStations(token: token);
    final myTripsResult = await _getMyTrips(token: token);

    String? error;

    final advertisings = advertisingsResult.fold(
      (failure) {
        error ??= failure.message;
        return const <AdvertisingEntity>[];
      },
      (ads) => ads,
    );

    final stations = stationsResult.fold(
      (failure) {
        error ??= failure.message;
        return const <StationEntity>[];
      },
      (stations) => stations,
    );

    final myTrips = myTripsResult.fold(
      (failure) {
        error ??= failure.message;
        return const <HomeTripEntity>[];
      },
      (trips) => trips,
    );

    if (error != null) {
      emit(HomeState.failure(
        message: error!,
        advertisings: advertisings,
        stations: stations,
        myTrips: myTrips,
        todayTrips: currentTodayTrips,
      ));
      return;
    }

    emit(HomeState.loaded(
      advertisings: advertisings,
      stations: stations,
      myTrips: myTrips,
      todayTrips: currentTodayTrips,
    ));
  }

  Future<void> loadTodayTrips({int? stationId, required String token}) async {
    final currentAds = state.maybeWhen(
      loading: (ads, _, __, ___) => ads,
      loaded: (ads, _, __, ___) => ads,
      failure: (_, ads, __, ___, ____) => ads,
      orElse: () => const <AdvertisingEntity>[],
    );
    final currentStations = state.maybeWhen(
      loading: (_, stations, __, ___) => stations,
      loaded: (_, stations, __, ___) => stations,
      failure: (_, __, stations, ___, ____) => stations,
      orElse: () => const <StationEntity>[],
    );
    final currentMyTrips = state.maybeWhen(
      loading: (_, __, myTrips, ___) => myTrips,
      loaded: (_, __, myTrips, ___) => myTrips,
      failure: (_, __, ___, myTrips, ____) => myTrips,
      orElse: () => const <HomeTripEntity>[],
    );
    final currentTodayTrips = state.maybeWhen(
      loading: (_, __, ___, todayTrips) => todayTrips,
      loaded: (_, __, ___, todayTrips) => todayTrips,
      failure: (_, __, ___, ____, todayTrips) => todayTrips,
      orElse: () => const <HomeTripEntity>[],
    );

    emit(HomeState.loading(
      advertisings: currentAds,
      stations: currentStations,
      myTrips: currentMyTrips,
      todayTrips: currentTodayTrips,
    ));

    final result = await _getTodayTrips(stationId: stationId, token: token);
    result.fold(
      (failure) {
        emit(HomeState.failure(
          message: failure.message,
          advertisings: currentAds,
          stations: currentStations,
          myTrips: currentMyTrips,
          todayTrips: const <HomeTripEntity>[],
        ));
      },
      (trips) {
        emit(HomeState.loaded(
          advertisings: currentAds,
          stations: currentStations,
          myTrips: currentMyTrips,
          todayTrips: trips,
        ));
      },
    );
  }
}

