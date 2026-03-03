import 'package:uot_transport/features/notifications_feature/domain/entities/notification_entity.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    this.body,
    required this.isRead,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final bool isRead;
  final DateTime? createdAt;

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  static NotificationModel fromApi(dynamic raw) {
    // Backend can return either a Map-shaped payload, or sometimes a string.
    if (raw is String) {
      return NotificationModel(
        id: raw.hashCode.toString(),
        title: raw,
        body: null,
        isRead: false,
        createdAt: null,
      );
    }

    if (raw is! Map) {
      return NotificationModel(
        id: raw.hashCode.toString(),
        title: raw.toString(),
        body: null,
        isRead: false,
        createdAt: null,
      );
    }

    final map = raw;

    final nestedData = map['data'];
    final nestedMap = nestedData is Map ? nestedData : const <String, dynamic>{};

    final id = (map['id'] ?? nestedMap['id'] ?? '').toString();
    final title = (map['title'] ?? nestedMap['title'] ?? '').toString();
    final body = (map['body'] ?? nestedMap['body'])?.toString();

    final readAt = map['read_at'] ?? map['readAt'] ?? nestedMap['read_at'] ?? nestedMap['readAt'];
    final isRead = (map['isRead'] == true) || readAt != null;

    DateTime? createdAt;
    final createdAtRaw = map['created_at'] ?? map['createdAt'] ?? nestedMap['created_at'] ?? nestedMap['createdAt'];
    if (createdAtRaw is String && createdAtRaw.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return NotificationModel(
      id: id.isEmpty ? raw.hashCode.toString() : id,
      title: title,
      body: (body != null && body.isEmpty) ? null : body,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

