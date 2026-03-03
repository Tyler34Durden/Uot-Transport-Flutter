import 'package:flutter_test/flutter_test.dart';
import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';
import 'package:uot_transport/features/notifications_feature/presentation/cubit/notifications_state.dart';

void main() {
  test('NotificationsState Freezed union exposes when/maybeWhen and compiles', () {
    const state = NotificationsState.initial();

    final label = state.when(
      initial: () => 'initial',
      loading: () => 'loading',
      loaded: (_) => 'loaded',
      error: (_) => 'error',
    );
    expect(label, 'initial');

    final list = state.maybeWhen(
      loaded: (n) => n,
      orElse: () => null,
    );
    expect(list, isNull);

    final loaded = NotificationsState.loaded(
      notifications: const <NotificationEntity>[],
    );

    expect(
      loaded.maybeWhen(loaded: (n) => n.length, orElse: () => -1),
      0,
    );
  });
}

