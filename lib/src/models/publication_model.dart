import 'package:hive/hive.dart';

part 'publication_model.g.dart';

@HiveType(typeId: 14)
class PublicationModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime? year;

  @HiveField(5)
  final int adminId;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  PublicationModel({
    required this.id,
    required this.title,
    required this.url,
    this.description,
    this.year,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    return PublicationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      url: json['url'] ?? "",
      year:
          json['year'] != null ? DateTime.parse(json['year']) : DateTime.now(),
      description: json['description'] ?? "",
      adminId: json['admin_id'] ?? 0,
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
      'title': title,
      'url': url,
      'admin_id': adminId,
      'description': description,
      'year': year?.toIso8601String() ?? "",
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
