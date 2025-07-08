class ContactUs {
  final int? id;
  final String? userId;
  final String? feature;
  final String? url;
  final String? email;
  final ContactUsData? data;
  // final Agent? agent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? section;
  final int? priority;
  final int? status;
  final int? isRead;
  final DateTime? deletedAt;

  ContactUs({
    this.id,
    this.userId,
    this.feature,
    this.url,
    this.email,
    this.data,
    // this.agent,
    this.createdAt,
    this.updatedAt,
    this.section,
    this.priority,
    this.status,
    this.isRead,
    this.deletedAt,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      id: json["id"],
      userId: json["user_id"],
      feature: json["feature"],
      url: json["url"],
      email: json["email"],
      data: json["data"] == null ? null : ContactUsData.fromJson(json["data"]),
      // agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      section: json["section"],
      priority: json["priority"],
      status: json["status"],
      isRead: json["is_read"],
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "feature": feature,
      "url": url,
      "email": email,
      "data": data?.toJson(),
      // "agent": agent?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "section": section,
      "priority": priority,
      "status": status,
      "is_read": isRead,
      "deleted_at": deletedAt,
    };
  }
}

class ContactUsData {
  final String? language;
  final String? name;
  final String? phoneCode;
  final String? phoneNumber;
  final String? website;
  final String? position;
  final String? meetingAppointment;
  final String? message;
  final List<String>? category;
  final ContactUsCompany? company;
  final String? portfolio;

  ContactUsData({
    this.language,
    this.name,
    this.phoneCode,
    this.phoneNumber,
    this.website,
    this.position,
    this.meetingAppointment,
    this.message,
    this.category,
    this.company,
    this.portfolio,
  });

  factory ContactUsData.fromJson(Map<String, dynamic> json) {
    return ContactUsData(
      language: json["language"],
      name: json["name"],
      phoneCode: json["phone_code"],
      phoneNumber: json["phone_number"].toString(),
      website: json["website"],
      position: json["position"],
      meetingAppointment: json["meeting_appointment"],
      message: json["message"],
      category: json["category"] == null
          ? []
          : json["category"] is String
              ? [(json["category"])]
              : List<String>.from(json["category"]),
      company: json["company"] == null
          ? null
          : json["company"] is String
              ? ContactUsCompany(name: json["company"])
              : ContactUsCompany.fromJson(json["company"]),
      portfolio: json["portfolio"] is! String ? null : json["portfolio"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "language": language,
      "name": name,
      "phone_code": phoneCode,
      "phone_number": phoneNumber,
      "website": website,
      "position": position,
      "meeting_appointment": meetingAppointment,
      "message": message,
      "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
      "company": company?.toJson(),
      "portfolio": portfolio,
    };
  }
}

class ContactUsCompany {
  final String? mail;
  final String? name;
  final String? size;
  final String? creative;

  ContactUsCompany({
    this.mail,
    this.name,
    this.size,
    this.creative,
  });

  factory ContactUsCompany.fromJson(Map<String, dynamic> json) {
    return ContactUsCompany(
      mail: json["mail"],
      name: json["name"],
      size: json["size"],
      creative: json["creative"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mail": mail,
      "name": name,
      "size": size,
      "creative": creative,
    };
  }
}
