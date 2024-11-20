import 'dart:io';

import 'package:hive/hive.dart';

part 'history_changes_model.g.dart';

@HiveType(typeId: 15)
class HistoryChangesModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int requestedId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final List<String?> type;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final int status;

  @HiveField(6)
  final List<int?> availableToUser;

  @HiveField(7)
  final File? file;

  @HiveField(8)
  final String createdBy;

  @HiveField(9)
  final String createdAtLabel;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  HistoryChangesModel({
    required this.id,
    required this.requestedId,
    required this.name,
    required this.type,
    this.note,
    required this.status,
    required this.availableToUser,
    this.file,
    required this.createdBy,
    required this.createdAtLabel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HistoryChangesModel.fromJson(Map<String, dynamic> json) {
    return HistoryChangesModel(
      id: json['id'] ?? 0,
      requestedId: json['data_request_id'] ?? 0,
      name: (json['name'] != null &&
              json['name'] is List &&
              json['name'].isNotEmpty)
          ? json['name'][0] ?? ""
          : "",
      type: (json['type'] != null && json['type'] is List)
        ? List<String>.from(json['type'].map((item) => item?.toString() ?? ""))
        : [],
      note: json['note'] ?? "",
      status: json['status'] ?? 0,
      createdBy: json['created_by'] ?? "",
      createdAtLabel: json['created_at_label'] ?? "",
      availableToUser: List<int?>.from(json['available_to_user'] ?? []),
      file: json['file'],
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
      'data_request_id': requestedId,
      'name': name,
      'type': type,
      'note': note,
      'status': status,
      'created_by': createdBy,
      'created_at_label': createdAtLabel,
      'available_to_user': availableToUser,
      'file': file,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
