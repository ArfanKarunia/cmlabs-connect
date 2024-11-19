import 'package:hive/hive.dart';

part 'experience_model.g.dart';

@HiveType(typeId: 8)
class ExperienceModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String position;

  @HiveField(2)
  final String company;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final DateTime? finishTime;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final int adminId;

  @HiveField(8)
  final int? projectId;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  ExperienceModel({
    required this.id,
    required this.position,
    required this.company,
    required this.type,
    required this.startTime,
    this.finishTime,
    required this.description,
    required this.adminId,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] ?? 0,
      position: json['position'] ?? "",
      company: json['company'] ?? "",
      type: json['type'] ?? "",
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : DateTime.now(), // Default to current date if null
      finishTime: json['finish_time'] != null
          ? DateTime.tryParse(json['finish_time'])
          : null, // Parse the finish_time if it's not null
      description: json['description'] ?? "",
      adminId: json['admin_id'] ?? 0,
      projectId: json['project_id'], // Handle nullable field
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'company': company,
      'type': type,
      'start_time': startTime.toIso8601String(),
      'finish_time': finishTime?.toIso8601String() ?? "",
      'description': description,
      'admin_id': adminId,
      'project_id': projectId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
