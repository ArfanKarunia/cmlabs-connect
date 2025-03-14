class CaseStudies {
  final int? id;
  final String? userId;
  final String? feature;
  final String? url;
  final String? email;
  final CaseStudiesData? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? section;
  final int? priority;
  final int? status;
  final int? isRead;
  final DateTime? deletedAt;

  CaseStudies({
    this.id,
    this.userId,
    this.feature,
    this.url,
    this.email,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.section,
    this.priority,
    this.status,
    this.isRead,
    this.deletedAt,
  });

  factory CaseStudies.fromJson(Map<String, dynamic> json) {
    return CaseStudies(
      id: json['id'],
      userId: json['user_id'],
      feature: json['feature'],
      url: json['url'],
      email: json['email'],
      data: json['data'] != null ? CaseStudiesData.fromJson(json['data']) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      section: json['section'],
      priority: json['priority'],
      status: json['status'],
      isRead: json['is_read'],
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'feature': feature,
      'url': url,
      'email': email,
      'data': data?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'section': section,
      'priority': priority,
      'status': status,
      'is_read': isRead,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class CaseStudiesData {
  final String? name;
  final String? phoneCode;
  final String? phoneNumber;
  final String? website;
  final String? company;
  final String? category;
  final String? message;

  CaseStudiesData({
    this.name,
    this.phoneCode,
    this.phoneNumber,
    this.website,
    this.company,
    this.category,
    this.message,
  });

  factory CaseStudiesData.fromJson(Map<String, dynamic> json) {
    return CaseStudiesData(
      name: json['name'],
      phoneCode: json['phone_code'],
      phoneNumber: json['phone_number'],
      website: json['website'],
      company: json['company'],
      category: json['category'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'website': website,
      'company': company,
      'category': category,
      'message': message,
    };
  }
}
