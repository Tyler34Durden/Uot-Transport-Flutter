import 'package:bloc/bloc.dart';

import '../../model/repository/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  NotificationsCubit(this.repository) : super(NotificationsInitial());

  Future<void> fetchNotifications(String token) async {
    emit(NotificationsLoading());
    try {
      final notifications = await repository.fetchNotifications(token);
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId, String token) async {
    try {
      await repository.markNotificationAsRead(notificationId, token);
      // Optionally, you can refresh notifications after marking as read:
      // await fetchNotifications(token);
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
