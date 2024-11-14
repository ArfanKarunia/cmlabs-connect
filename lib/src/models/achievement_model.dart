import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 12)
class AchievementModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime year;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String institutionName;

  @HiveField(5)
  final int adminId;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  AchievementModel({
    required this.id,
    required this.name,
    required this.year,
    required this.institutionName,
    this.description,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      year:
          json['year'] != null ? DateTime.parse(json['year']) : DateTime.now(),
      adminId: json['admin_id'] ?? 0,
      institutionName: json['institution_name'] ?? "",
      description: json['description'] ?? "",
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
      'name': name,
      'year': year,
      'institution_name': institutionName,
      'admin_id': adminId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
