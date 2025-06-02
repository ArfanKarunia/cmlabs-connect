import 'dart:io';

class HistoryChangesModel {
  final int id;
  final int requestedId;
  final String name;
  final List<String?> type;
  final String? note;
  final int status;
  final List<int?> availableToUser;
  final File? file;
  final String createdBy;
  final String createdAtLabel;
  final DateTime createdAt;
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
      name: (json['name'] != null && json['name'] is List && json['name'].isNotEmpty) ? json['name'][0] ?? "" : "",
      type: (json['type'] != null && json['type'] is List)
          ? List<String>.from(json['type'].map((item) => item?.toString() ?? ""))
          : [],
      note: json['note'] ?? "",
      status: json['status'] ?? 0,
      createdBy: json['created_by'] ?? "",
      createdAtLabel: json['created_at_label'] ?? "",
      availableToUser: List<int?>.from(json['available_to_user'] ?? []),
      file: json['file'] != null ? File(json['file']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
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
