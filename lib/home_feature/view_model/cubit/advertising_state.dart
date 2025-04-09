class AdvertisingsState {
  @override
  List<Object?> get props => [];
}

class AdvertisingsInitial extends AdvertisingsState {}

class AdvertisingsLoading extends AdvertisingsState {}

class AdvertisingsLoaded extends AdvertisingsState {
  final List<dynamic> advertisings;

  AdvertisingsLoaded(this.advertisings);

  @override
  List<Object?> get props => [advertisings];
}

class AdvertisingsError extends AdvertisingsState {
  final String message;

  AdvertisingsError(this.message);

  @override
  List<Object?> get props => [message];
}