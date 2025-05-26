class VolunteerModel {
  final int id;
  final String name;
  final String position;
  final String division;
  final String? description;
  final DateTime startTime;
  final DateTime? finishTime;
  final int adminId;
  final DateTime createdAt;
  final DateTime updatedAt;

  VolunteerModel({
    required this.id,
    required this.name,
    required this.position,
    required this.division,
    this.description,
    required this.startTime,
    this.finishTime,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VolunteerModel.fromJson(Map<String, dynamic> json) {
    return VolunteerModel(
      id: json['id'] ?? 0,
      name: json['activity_name'] ?? "",
      position: json['position'] ?? "",
      division: json['division'] ?? "",
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : DateTime.now(), // Default to current date if null
      finishTime: json['finish_time'] != null
          ? DateTime.tryParse(json['finish_time'])
          : null, // Parse the finish_time if it's not null
      description: json['description'] ?? "",
      adminId: json['admin_id'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_name': name,
      'position': position,
      'division': division,
      'admin_id': adminId,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'finish_time': finishTime?.toIso8601String() ?? "",
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
