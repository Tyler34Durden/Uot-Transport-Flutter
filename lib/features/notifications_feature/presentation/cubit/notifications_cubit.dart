import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/get_notifications_usecase.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/mark_notification_read_usecase.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotificationsUseCase getNotifications,
    required MarkNotificationReadUseCase markNotificationRead,
    required MarkAllNotificationsReadUseCase markAllNotificationsRead,
  })  : _getNotifications = getNotifications,
        _markNotificationRead = markNotificationRead,
        _markAllNotificationsRead = markAllNotificationsRead,
        super(const NotificationsState.initial());

  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationReadUseCase _markNotificationRead;
  final MarkAllNotificationsReadUseCase _markAllNotificationsRead;

  Future<void> fetchNotifications(String token) async {
    emit(const NotificationsState.loading());
    try {
      final notifications = await _getNotifications(token);
      emit(NotificationsState.loaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsState.error(message: e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId, String token) async {
    try {
      await _markNotificationRead(id: notificationId, token: token);
    } catch (e) {
      emit(NotificationsState.error(message: e.toString()));
    }
  }

  Future<void> markAllAsRead(String token) async {
    try {
      await _markAllNotificationsRead(token);
    } catch (_) {
      // ignore
    }
  }
}
