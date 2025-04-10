abstract class StationsState {}

class StationsInitial extends StationsState {}

class StationsLoading extends StationsState {}

class StationsSuccess extends StationsState {
  final List<dynamic> stations;
  StationsSuccess(this.stations);
}

class StationsFailure extends StationsState {
  final String error;
  StationsFailure(this.error);
}