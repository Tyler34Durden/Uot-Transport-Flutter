import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';

part 'stations_state.freezed.dart';

@freezed
class StationsState with _$StationsState {
  const factory StationsState.initial() = _StationsInitial;
  const factory StationsState.loading() = _StationsLoading;
  const factory StationsState.loaded({required List<StationEntity> stations}) = _StationsLoaded;
  const factory StationsState.failure({required Failure failure}) = _StationsFailure;
}
