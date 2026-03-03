import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile_model.dart';

class ProfileLocalDataSource {
  const ProfileLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _kToken = 'auth_token';
  static const _kUserId = 'user_id';
  static const _kUserProfile = 'user_profile';

  String? getToken() => _prefs.getString(_kToken);
  int? getUserId() => _prefs.getInt(_kUserId);

  UserProfileModel? getCachedProfile() {
    final raw = _prefs.getString(_kUserProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserProfileModel.fromJson(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheProfile(UserProfileModel profile) async {
    await _prefs.setString(_kUserProfile, jsonEncode(profile.toJson()));
  }

  Future<void> clearSession() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUserProfile);
    await _prefs.remove(_kUserId);
  }
}

