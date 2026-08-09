class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
}
