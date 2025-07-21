class CertificationModel {
  final int id;
  final String name;
  final String url;
  final String institutionName;
  final String? description;
  final String? pic;
  final DateTime startTime;
  final DateTime? finishTime;
  final int adminId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CertificationModel({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    this.pic,
    required this.adminId,
    required this.institutionName,
    required this.startTime,
    this.finishTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      url: json['url'] ?? "",
      pic: json['pic'] ?? "",
      institutionName: json['institution_name'] ?? "",
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
      'name': name,
      'url': url,
      'pic': pic,
      'admin_id': adminId,
      'institution_name': institutionName,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'finish_time': finishTime?.toIso8601String() ?? "",
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
