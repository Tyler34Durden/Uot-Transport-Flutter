import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-level, feature-agnostic state.
///
/// Use this as the single source of truth for:
/// - whether the user is authenticated
/// - current token/user id
/// - clearing session on logout
sealed class AppState {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppUnauthenticated extends AppState {
  const AppUnauthenticated();
}

class AppAuthenticated extends AppState {
  const AppAuthenticated({required this.token, required this.userId});

  final String token;
  final int userId;
}

class AppCubit extends Cubit<AppState> {
  AppCubit(this._prefs) : super(const AppInitial());

  final SharedPreferences _prefs;

  /// Call once on app start (e.g., from SplashScreen) to decide where to navigate.
  Future<void> initialize() async {
    final token = _prefs.getString('auth_token');
    final userId = _prefs.getInt('user_id');

    if (token == null || token.trim().isEmpty) {
      emit(const AppUnauthenticated());
      return;
    }

    emit(AppAuthenticated(token: token, userId: userId ?? 0));
  }

  /// Call after login to update global state.
  void setSession({required String token, required int userId}) {
    _prefs.setString('auth_token', token);
    _prefs.setInt('user_id', userId);
    emit(AppAuthenticated(token: token, userId: userId));
  }

  /// Clears local session and emits unauthenticated.
  Future<void> logout() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
    emit(const AppUnauthenticated());
  }
}
