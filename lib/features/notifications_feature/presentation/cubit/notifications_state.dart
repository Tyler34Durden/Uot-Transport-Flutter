import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;
  const factory NotificationsState.loading() = _Loading;
  const factory NotificationsState.loaded({
    required List<NotificationEntity> notifications,
  }) = _Loaded;
  const factory NotificationsState.error({
    required String message,
  }) = _Error;
}
