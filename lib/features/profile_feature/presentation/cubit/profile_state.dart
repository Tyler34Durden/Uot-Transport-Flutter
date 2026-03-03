import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile_entity.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;

  const factory ProfileState.loaded({required UserProfileEntity profile}) = _Loaded;

  /// Used for update phone / change password.
  const factory ProfileState.actionSuccess({
    required String message,
    UserProfileEntity? profile,
  }) = _ActionSuccess;

  const factory ProfileState.error({required String message}) = _Error;

  const factory ProfileState.loggedOut() = _LoggedOut;
}
