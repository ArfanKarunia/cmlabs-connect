class Faq {
  final int? id;
  final String? name;
  final String? companyName;
  final String? whatsappNumber;
  final String? question;
  final String? shortQuestion;

  final String? userId;
  final String? feature;
  final String? url;
  final String? email;
  final FaqDetailData? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? section;
  final int? priority;
  final int? status;
  final int? isRead;
  final DateTime? deletedAt;

  Faq({
    required this.id,
    required this.name,
    required this.companyName,
    this.whatsappNumber,
    this.question,
    this.shortQuestion,
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

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'],
      name: json['name'] ?? json['data']?['name'],
      companyName: json['company_name'] ?? json['data']?['company-name'],
      whatsappNumber: json['whatsapp_number'] ?? json['data']?['phone_number'],
      question: json['question'] ?? json['data']?['question'],
      shortQuestion: json['short_question'],
      userId: json['user_id'],
      feature: json['feature'],
      url: json['url'],
      email: json['email'],
      data: json['data'] != null && json['data'] is Map<String, dynamic> ? FaqDetailData.fromJson(json['data']) : null,
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      section: json['section'],
      priority: json['priority'],
      status: json['status'],
      isRead: json['is_read'],
      deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
    );
  }

  Faq copyWith({
    int? id,
    String? name,
    String? companyName,
    String? whatsappNumber,
    String? question,
    String? shortQuestion,
    String? userId,
    String? feature,
    String? url,
    String? email,
    FaqDetailData? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? section,
    int? priority,
    int? status,
    int? isRead,
    DateTime? deletedAt,
  }) {
    return Faq(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      question: question ?? this.question,
      shortQuestion: shortQuestion ?? this.shortQuestion,
      userId: userId ?? this.userId,
      feature: feature ?? this.feature,
      url: url ?? this.url,
      email: email ?? this.email,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      section: section ?? this.section,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class FaqDetailData {
  final String? name;
  final String? phoneCode;
  final String? phoneNumber;
  final String? website;
  final String? companyName;
  final String? question;

  FaqDetailData({
    required this.name,
    required this.phoneCode,
    required this.phoneNumber,
    required this.website,
    required this.companyName,
    required this.question,
  });

  factory FaqDetailData.fromJson(Map<String, dynamic> json) {
    return FaqDetailData(
      name: json['name'],
      phoneCode: json['phone_code'],
      phoneNumber: json['phone_number'],
      website: json['website'],
      companyName: json['company-name'],
      question: json['question'],
    );
  }

  FaqDetailData copyWith({
    String? name,
    String? phoneCode,
    String? phoneNumber,
    String? website,
    String? companyName,
    String? question,
  }) {
    return FaqDetailData(
      name: name ?? this.name,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      companyName: companyName ?? this.companyName,
      question: question ?? this.question,
    );
  }
}
