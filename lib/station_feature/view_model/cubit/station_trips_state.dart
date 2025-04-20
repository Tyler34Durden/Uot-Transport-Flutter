abstract class StationTripsState {}

class StationTripsInitial extends StationTripsState {}

class StationTripsLoading extends StationTripsState {}

class StationTripsSuccess extends StationTripsState {
  final List<dynamic> trips;
  StationTripsSuccess(this.trips);
}

class StationTripsFailure extends StationTripsState {
  final String error;
  StationTripsFailure(this.error);
}