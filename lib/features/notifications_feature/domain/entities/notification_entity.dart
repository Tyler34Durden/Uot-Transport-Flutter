class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    this.body,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final bool isRead;
  final DateTime? createdAt;
}

