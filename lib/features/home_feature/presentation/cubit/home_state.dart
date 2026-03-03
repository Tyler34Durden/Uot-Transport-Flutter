import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uot_transport/features/home_feature/domain/entities/advertising_entity.dart';
import 'package:uot_transport/features/home_feature/domain/entities/home_trip_entity.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.loading({
    @Default(<AdvertisingEntity>[]) List<AdvertisingEntity> advertisings,
    @Default(<StationEntity>[]) List<StationEntity> stations,
    @Default(<HomeTripEntity>[]) List<HomeTripEntity> myTrips,
    @Default(<HomeTripEntity>[]) List<HomeTripEntity> todayTrips,
  }) = _Loading;

  const factory HomeState.loaded({
    required List<AdvertisingEntity> advertisings,
    required List<StationEntity> stations,
    required List<HomeTripEntity> myTrips,
    required List<HomeTripEntity> todayTrips,
  }) = _Loaded;

  const factory HomeState.failure({
    required String message,
    @Default(<AdvertisingEntity>[]) List<AdvertisingEntity> advertisings,
    @Default(<StationEntity>[]) List<StationEntity> stations,
    @Default(<HomeTripEntity>[]) List<HomeTripEntity> myTrips,
    @Default(<HomeTripEntity>[]) List<HomeTripEntity> todayTrips,
  }) = _Failure;
}
