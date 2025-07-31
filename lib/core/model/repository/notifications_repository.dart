import 'package:uot_transport/core/api_service.dart';

class NotificationsRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchNotifications(String token) async {
    try {
      final response = await _apiService.getRequest('notifications', token: token);
      if (response.data is Map && response.data['notifications'] is List) {
        // Return the full notification object for each notification
        return (response.data['notifications'] as List);
      } else if (response.data is List) {
        return (response.data as List);
      } else if (response.data is Map && response.data['data'] is List) {
        return (response.data['data'] as List);
      } else {
        print('DEBUG: Unexpected notifications data format: \n${response.data}');
        throw Exception('Invalid notifications data format: \n${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String notificationId, String token) async {
    try {
      await _apiService.patchRequest('notifications/$notificationId/read', {}, token: token);
    } catch (e) {
      rethrow;
    }
  }
}
