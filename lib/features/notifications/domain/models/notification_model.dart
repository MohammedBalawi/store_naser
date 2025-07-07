class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final bool? isRead; // أضفنا هذا

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
     this.isRead, // أضفناه هنا
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      isRead: json['is_read'] ?? false, // أضفناه هنا
    );
  }
}
