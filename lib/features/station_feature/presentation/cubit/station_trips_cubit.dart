import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_station_trips_usecase.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/station_trips_state.dart';
class StationTripsCubit extends Cubit<StationTripsState> {
  StationTripsCubit({required GetStationTripsUseCase getStationTripsUseCase})
      : _getStationTripsUseCase = getStationTripsUseCase,
        super(const StationTripsState.initial());
  final GetStationTripsUseCase _getStationTripsUseCase;
  Future<void> fetchStationTrips({
    required int stationId,
    required String token,
  }) async {
    emit(const StationTripsState.loading());
    final result = await _getStationTripsUseCase(
      GetStationTripsParams(stationId: stationId, token: token),
    );
    result.fold(
      (failure) => emit(StationTripsState.failure(failure: failure)),
      (trips) => emit(StationTripsState.loaded(trips: trips)),
    );
  }
}
