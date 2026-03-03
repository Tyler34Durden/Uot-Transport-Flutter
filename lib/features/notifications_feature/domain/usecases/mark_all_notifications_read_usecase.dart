import 'package:uot_transport/features/notifications_feature/domain/repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<void> call(String token) {
    return _repository.markAllAsRead(token);
  }
}
