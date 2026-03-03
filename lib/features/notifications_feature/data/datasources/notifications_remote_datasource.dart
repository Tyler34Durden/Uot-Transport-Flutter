import 'package:uot_transport/core/api_service.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<dynamic>> fetchNotifications(String token);

  Future<void> markNotificationAsRead(String notificationId, String token);

  Future<void> markAllAsRead(String token);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<dynamic>> fetchNotifications(String token) async {
    final response = await _apiService.getRequest('notifications', token: token);

    if (response.data is Map && response.data['notifications'] is List) {
      return (response.data['notifications'] as List);
    }
    if (response.data is List) {
      return (response.data as List);
    }
    if (response.data is Map && response.data['data'] is List) {
      return (response.data['data'] as List);
    }

    throw Exception('Invalid notifications data format: ${response.data}');
  }

  @override
  Future<void> markNotificationAsRead(String notificationId, String token) async {
    await _apiService.patchRequest('notifications/$notificationId/read', {}, token: token);
  }

  @override
  Future<void> markAllAsRead(String token) async {
    await _apiService.patchRequest('notifications/read-all', {}, token: token);
  }
}

