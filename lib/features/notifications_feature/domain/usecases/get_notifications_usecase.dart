import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';
import 'package:uot_transport/features/notifications_feature/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<List<NotificationEntity>> call(String token) {
    return _repository.getNotifications(token);
  }
}

