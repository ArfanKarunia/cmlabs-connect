class PublicationModel {
  final int id;
  final String title;
  final String url;
  final String? description;
  final DateTime? year;
  final int adminId;
  final DateTime createdAt;
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
      year: json['year'] != null ? DateTime.parse(json['year']) : DateTime.now(),
      description: json['description'] ?? "",
      adminId: json['admin_id'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
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
