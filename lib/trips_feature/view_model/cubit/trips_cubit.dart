import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
  import 'trips_state.dart';

  class TripsCubit extends Cubit<TripsState> {
    final HomeRepository _repository;

    TripsCubit(this._repository) : super(TripsInitial());

    Future<void> fetchTodayTrips() async {
      emit(TripsLoading());
      try {
        final trips = await _repository.fetchTodayTrips();
        emit(TripsLoaded(trips));
      } catch (e) {
        emit(TripsError(e.toString()));
      }
    }
  }