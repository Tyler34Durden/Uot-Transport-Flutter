import 'package:uot_transport/features/notifications_feature/domain/repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<void> call({required String id, required String token}) {
    return _repository.markAsRead(id: id, token: token);
  }
}

