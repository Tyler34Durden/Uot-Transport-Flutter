class TripsState {
  @override
  List<Object?> get props => [];
}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsLoaded extends TripsState {
  final List<dynamic> trips;

  TripsLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class TripsError extends TripsState {
  final String error;

  TripsError(this.error);

  @override
  List<Object?> get props => [error];
}

// States for Trip Routes
class TripRoutesLoading extends TripsState {}

class TripRoutesLoaded extends TripsState {
  final List<Map<String, dynamic>> tripRoutes;

  TripRoutesLoaded(this.tripRoutes);

  @override
  List<Object?> get props => [tripRoutes];
}

class TripRoutesError extends TripsState {
  final String error;

  TripRoutesError(this.error);

  @override
  List<Object?> get props => [error];
}

class TripsTicketLoading extends TripsState {}

class TripsTicketSuccess extends TripsState {
  final String message;

  TripsTicketSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TripsTicketError extends TripsState {
  final String error;

  TripsTicketError(this.error);

  @override
  List<Object?> get props => [error];
}

class TripDetailsLoading extends TripsState {}

class TripDetailsLoaded extends TripsState {
  final Map <String, dynamic> tripDetails;

  TripDetailsLoaded(this.tripDetails);

  @override
  List<Object?> get props => [tripDetails];
}

class TripDetailsError extends TripsState {
  final String error;

  TripDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}