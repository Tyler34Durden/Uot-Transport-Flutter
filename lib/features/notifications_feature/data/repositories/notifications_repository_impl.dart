import 'package:uot_transport/features/notifications_feature/data/datasources/notifications_remote_datasource.dart';
import 'package:uot_transport/features/notifications_feature/data/models/notification_model.dart';
import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';
import 'package:uot_transport/features/notifications_feature/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<List<NotificationEntity>> getNotifications(String token) async {
    final rawList = await _remote.fetchNotifications(token);
    return rawList.map((e) => NotificationModel.fromApi(e).toEntity()).toList(growable: false);
  }

  @override
  Future<void> markAllAsRead(String token) {
    return _remote.markAllAsRead(token);
  }

  @override
  Future<void> markAsRead({required String id, required String token}) {
    return _remote.markNotificationAsRead(id, token);
  }
}

