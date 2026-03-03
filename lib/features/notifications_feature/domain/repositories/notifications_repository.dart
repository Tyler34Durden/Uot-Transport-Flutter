import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications(String token);

  Future<void> markAsRead({required String id, required String token});

  Future<void> markAllAsRead(String token);
}

