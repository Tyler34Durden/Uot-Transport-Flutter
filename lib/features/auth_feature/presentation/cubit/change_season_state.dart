import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_season_state.freezed.dart';

@freezed
class ChangeSeasonState with _$ChangeSeasonState {
  const factory ChangeSeasonState.initial() = _ChangeSeasonInitial;
  const factory ChangeSeasonState.loading() = _ChangeSeasonLoading;
  const factory ChangeSeasonState.success() = _ChangeSeasonSuccess;
  const factory ChangeSeasonState.failure({required String message}) = _ChangeSeasonFailure;
}
