import 'dart:convert';

class ProjectHistory {
  final int? id;
  final int? dataRequestId;
  final String? name;
  final List<String>? type;
  final String? note;
  final int? status;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? availableToUser;
  final String? file;

  ProjectHistory({
    this.id,
    this.dataRequestId,
    this.name,
    this.type,
    this.note,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.availableToUser,
    this.file,
  });

  ProjectHistory copyWith({
    int? id,
    int? dataRequestId,
    String? name,
    List<String>? type,
    String? note,
    int? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? availableToUser,
    String? file,
  }) {
    return ProjectHistory(
      id: id ?? this.id,
      dataRequestId: dataRequestId ?? this.dataRequestId,
      name: name ?? this.name,
      type: type ?? this.type,
      note: note ?? this.note,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      availableToUser: availableToUser ?? this.availableToUser,
      file: file ?? this.file,
    );
  }

  factory ProjectHistory.fromJson(Map<String, dynamic> json) {
    List<String>? parseType(dynamic typeData) {
      if (typeData == null) return null;
      if (typeData is List) return typeData.map((item) => item.toString()).toList();
      if (typeData is String && (typeData.startsWith('[') && typeData.endsWith(']'))) {
        try {
          List<dynamic> parsedList = jsonDecode(typeData);
          return parsedList.map((item) => item.toString()).toList();
        } catch (e) {
          return [typeData];
        }
      }
      if (typeData is String) return [typeData];

      return null;
    }

    return ProjectHistory(
      id: json['id'],
      dataRequestId: json['data_request_id'],
      name: json['name'],
      type: parseType(json['type']),
      note: json['note'],
      status: json['status'],
      createdBy: json['created_by'] == 1 ? 'Super Admin' : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      availableToUser: json['available_to_user'] == 1
          ? true
          : json['available_to_user'] == true
              ? true
              : false,
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'note': note,
      'status': status,
      // 'created_by': UserController,
      'available_to_user': availableToUser,
      'file': file,
    };
  }
}
