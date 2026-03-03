import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_searched_stations_usecase.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_stations_usecase.dart';

import 'stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  StationsCubit({
    required GetStationsUseCase getStationsUseCase,
    required GetSearchedStationsUseCase getSearchedStationsUseCase,
  })  : _getStationsUseCase = getStationsUseCase,
        _getSearchedStationsUseCase = getSearchedStationsUseCase,
        super(const StationsState.initial());

  final GetStationsUseCase _getStationsUseCase;
  final GetSearchedStationsUseCase _getSearchedStationsUseCase;

  Future<void> fetchStations() async {
    emit(const StationsState.loading());

    final result = await _getStationsUseCase();
    result.fold(
      (failure) => emit(StationsState.failure(failure: failure)),
      (stations) => emit(StationsState.loaded(stations: stations)),
    );
  }

  Future<void> searchStations(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      return fetchStations();
    }

    emit(const StationsState.loading());
    final result = await _getSearchedStationsUseCase(
      GetSearchedStationsParams(name: q),
    );

    result.fold(
      (failure) => emit(StationsState.failure(failure: failure)),
      (stations) => emit(
        StationsState.loaded(stations: (stations as List).cast<StationEntity>()),
      ),
    );
  }
}
