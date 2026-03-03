import 'package:flutter_test/flutter_test.dart';
import 'package:uot_transport/features/profile_feature/domain/entities/user_profile_entity.dart';
import 'package:uot_transport/features/profile_feature/presentation/cubit/profile_state.dart';

void main() {
  test('ProfileState Freezed union exposes when/maybeWhen and compiles', () {
    const state = ProfileState.initial();
    final label = state.when(
      initial: () => 'initial',
      loading: () => 'loading',
      loaded: (_) => 'loaded',
      actionSuccess: (_, __) => 'actionSuccess',
      error: (_) => 'error',
      loggedOut: () => 'loggedOut',
    );
    expect(label, 'initial');

    final msg = state.maybeWhen(
      error: (m) => m,
      orElse: () => 'ok',
    );
    expect(msg, 'ok');

    const loaded = ProfileState.loaded(
      profile: UserProfileEntity(
        id: 1,
        fullName: 'Test User',
        role: 'student',
        uotNumber: 'UOT-0001',
        email: 'test@example.com',
        userZone: 'Zone',
        phone: '000',
        profilePhoto: null,
      ),
    );

    expect(
      loaded.maybeWhen(loaded: (p) => p.fullName, orElse: () => ''),
      'Test User',
    );
  });
}
