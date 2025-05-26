class NotificationModel {
  final int id;
  final int status;
  final int priority;
  final String company;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRead;
  final bool isRemainder;

  NotificationModel({
    required this.id,
    required this.status,
    required this.priority,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
    this.isRemainder = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now();
    DateTime updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now();

    bool isRemainder = json['status'] == 0 && DateTime.now().difference(createdAt).inHours > 24;

    return NotificationModel(
      id: json['id'] ?? 0,
      priority: json['priority'] ?? 0,
      status: json['status'] ?? 0,
      company: json['data']['company_name'] ?? json['data']['company'] ?? '-',
      isRead: json['is_read'] == 0 ? false : true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isRemainder: isRemainder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'priority': priority,
      'status': status,
      'company': company,
      'is_read': isRead,
      'is_remainder': isRemainder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
