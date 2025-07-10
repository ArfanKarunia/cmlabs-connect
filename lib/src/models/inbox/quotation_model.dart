import 'package:cmlabs_connect/src/models/inbox/property/client_pic_model.dart';
import 'package:cmlabs_connect/src/models/inbox/property/client_source_model.dart';

import 'property/project_history_model.dart';

class Quotation {
  final int? id;
  final String? userId;
  final String? feature;
  final String? url;
  final String? email;
  final QuotationData? data;
  final AgentData? agent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? section;
  final int? priority;
  final int? status;
  final int? isRead;
  final DateTime? deletedAt;

  Quotation({
    this.id,
    this.userId,
    this.feature,
    this.url,
    this.email,
    this.data,
    this.agent,
    this.createdAt,
    this.updatedAt,
    this.section,
    this.priority,
    this.status,
    this.isRead,
    this.deletedAt,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      userId: json['user_id'].toString(),
      feature: json['feature'],
      url: json['url'],
      email: json['email'],
      data: json['data'] != null ? QuotationData.fromJson(json['data']) : null,
      agent: json['agent'] != null ? AgentData.fromJson(json['agent']) : null,
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
      'agent': agent?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'section': section,
      'priority': priority,
      'status': status,
      'is_read': isRead,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Quotation copyWith({
    int? id,
    String? userId,
    String? feature,
    String? url,
    String? email,
    QuotationData? data,
    AgentData? agent,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? section,
    int? priority,
    int? status,
    int? isRead,
    DateTime? deletedAt,
  }) {
    return Quotation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feature: feature ?? this.feature,
      url: url ?? this.url,
      email: email ?? this.email,
      data: data ?? this.data,
      agent: agent ?? this.agent,
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

class QuotationData {
  final String? name;
  final String? phoneCode;
  final String? phoneNumber;
  final String? website;
  final String? company;
  final String? companyProfile;
  final String? registrationStatus;
  final String? region;

  final List<String>? category;
  final String? pic;
  final ClientSource? clientSource;
  final List<String?>? type;

  final List<ProjectHistory?>? activities;
  final String? remarks;
  final String? notes;

  final List<ClientPic?>? clientPIC;

  final String? message;

  QuotationData({
    this.name,
    this.phoneCode,
    this.phoneNumber,
    this.website,
    this.company,
    this.companyProfile,
    this.registrationStatus,
    this.region,
    this.category,
    this.pic,
    this.clientSource,
    this.type,
    this.activities,
    this.remarks,
    this.notes,
    this.clientPIC,
    this.message,
  });

  factory QuotationData.fromJson(Map<String, dynamic> json) {
    List<ClientPic> clientPics = [];
    if (json['client_pic'] is List) {
      clientPics = (json['client_pic'] as List<dynamic>?)?.map((picJson) => ClientPic.fromJson(picJson)).toList() ?? [];
    } else if (json['client_pic'] is Map) {
      clientPics = (json['client_pic'] as Map<String, dynamic>?)
              ?.values
              .map((picJson) => ClientPic.fromJson(picJson))
              .toList() ??
          [];
    }

    List<String> types = [];
    if (json['type'] != null) {
      if (json['type'] is String) {
        types = [json['type']];
      } else if (json['type'] is List) {
        if (json['type'].every((element) => element == null)) {
          types = [];
        } else {
          types = List<String>.from(json['type'].where((element) => element != null));
        }
      }
    }

    List<String> categories = [];
    if (json['category'] != null) {
      if (json['category'] is String) {
        categories = [json['category']];
      } else if (json['category'] is List) {
        categories = List<String>.from(json['category']);
      }
    }

    return QuotationData(
      name: json['name'] ?? '-',
      phoneCode: json['phone_code'] ?? '-',
      phoneNumber: json['phone_number'] ?? '-',
      company: json['company_name'] ?? json['company'] ?? '-',
      registrationStatus: json['registration-status'] ?? '-',
      website: json['website'] ?? '-',
      region: json['region'] ?? '-',
      type: types,
      category: categories,
      clientPIC: clientPics,
      pic: json['pic'] ?? '-',
      remarks: json['remarks'] ?? '-',
      notes: json['notes'] ?? '-',
      clientSource: ClientSource.fromJson(
        {'client_source': json['client_source'], ...?json['client_source_detail']},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'registration-status': registrationStatus,
      'website': website,
      'region': region,
      'type': type,
      'category': category,
      'client_pic': clientPIC, // Ubah ini sesuai struktur ClientPic
      'remarks': remarks,
      'notes': notes,
      'client_source': clientSource?.toJson()
    };
  }

  QuotationData copyWith({
    String? name,
    String? phoneCode,
    String? phoneNumber,
    String? website,
    String? company,
    String? companyProfile,
    String? registrationStatus,
    String? region,
    List<String>? category,
    String? pic,
    ClientSource? clientSource,
    List<String?>? type,
    List<ProjectHistory?>? activities,
    String? remarks,
    String? notes,
    List<ClientPic?>? clientPIC,
    String? message,
  }) {
    return QuotationData(
      name: name ?? this.name,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      company: company ?? this.company,
      companyProfile: companyProfile ?? this.companyProfile,
      registrationStatus: registrationStatus ?? this.registrationStatus,
      region: region ?? this.region,
      category: category ?? this.category,
      pic: pic ?? this.pic,
      clientSource: clientSource ?? this.clientSource,
      type: type ?? this.type,
      activities: activities ?? this.activities,
      remarks: remarks ?? this.remarks,
      notes: notes ?? this.notes,
      clientPIC: clientPIC ?? this.clientPIC,
      message: message ?? this.message,
    );
  }
}

class AgentData {
  final String? browser;
  final String? device;
  final String? ip;
  final List<String?>? language;
  final String? platform;
  final String? devices;

  AgentData({
    this.browser,
    this.device,
    this.ip,
    this.language,
    this.platform,
    this.devices,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) {
    try {
      return AgentData(
        browser: json['browser'] is String ? json['browser'] : null,
        device: json['device'] is String ? json['device'] : null,
        ip: json['ip'],
        language: json['language'] is String ? [json['language']] : List<String>.from(json['language'] ?? []),
        platform: json['platform'] is String ? json['platform'] : null,
        devices: json['devices'] is String ? json['devices'] : null,
      );
    } catch (e) {
      return AgentData();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'browser': browser,
      'device': device,
      'ip': ip,
      'language': language,
      'platform': platform,
      'devices': devices,
    };
  }
}

class DetailQuotation {
  final int? id;
  final String? companyName;
  final String? companyWebsite;
  final String? phoneNumber;
  final String? phoneCode;
  final List<String>? typeInformation;
  final String? clientSource;
  final ClientSource? clientSourceDetail;
  final int? status;
  final int? priority;
  final DateTime? createdAt;
  final String? feature;
  final String? section;
  final String? url;
  final List<ClientPic>? clientPic;
  final String? cmlabspic;
  final List<String>? category;
  final AgentData? agent;
  final String? email;
  final List<ProjectHistory>? activities;

  DetailQuotation({
    this.id,
    this.companyName,
    this.companyWebsite,
    this.phoneNumber,
    this.phoneCode,
    this.typeInformation,
    this.clientSource,
    this.clientSourceDetail,
    this.status,
    this.priority,
    this.createdAt,
    this.feature,
    this.section,
    this.url,
    this.clientPic,
    this.cmlabspic,
    this.category,
    this.agent,
    this.email,
    this.activities,
  });

  factory DetailQuotation.fromJson(Map<String, dynamic> json) {
    List<ClientPic> clientPics = [];
    if (json['data']['client_pic'] is List) {
      clientPics =
          (json['data']['client_pic'] as List<dynamic>?)?.map((picJson) => ClientPic.fromJson(picJson)).toList() ?? [];
    }

    List<ProjectHistory> activitiesList = [];
    if (json['activities'] is List) {
      activitiesList = (json['activities'] as List<dynamic>?)
              ?.map((activityJson) => ProjectHistory.fromJson(activityJson))
              .toList() ??
          [];
    }

    return DetailQuotation(
      id: json['data']['id'],
      companyName: json['data']['company_name'],
      companyWebsite: json['data']['company_website'],
      phoneNumber: json['data']['phone_number'],
      phoneCode: json['data']['phone_code'],
      typeInformation: json['data']['typeInformation'] != null
          ? json['data']['typeInformation'] is List
              ? List<String>.from(json['data']['typeInformation'])
              : [json['data']['typeInformation']]
          : null,
      clientSource: json['data']['client_source'],
      clientSourceDetail: json['data']['client_source_detail'] != null
          ? ClientSource.fromJson(json['data']['client_source_detail'])
          : null,
      status: json['data']['status'],
      priority: json['data']['priority'],
      createdAt: json['data']['created_at'] != null ? DateTime.tryParse(json['data']['created_at']) : null,
      feature: json['data']['feature'],
      section: json['data']['section'],
      url: json['data']['url'],
      clientPic: clientPics,
      cmlabspic: json['data']['cmlabspic'],
      category: json['data']['category'] != null
          ? json['data']['category'] is List
              ? List<String>.from(json['data']['category'])
              : [json['data']['category']]
          : null,
      // agent: json['data']['agent'] != null ? AgentData.fromJson(json['data']['agent']) : null,
      email: json['data']['email'],
      activities: activitiesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'company_website': companyWebsite,
      'phone_number': phoneNumber,
      'phone_code': phoneCode,
      'typeInformation': typeInformation,
      'client_source': clientSource,
      'client_source_detail': clientSourceDetail?.toJson(),
      'status': status,
      'priority': priority,
      'created_at': createdAt?.toIso8601String(),
      'feature': feature,
      'section': section,
      'url': url,
      'client_pic': clientPic?.map((pic) => pic.toJson()).toList(),
      'cmlabspic': cmlabspic,
      'category': category,
      'agent': agent?.toJson(),
      'email': email,
      'activities': activities?.map((activity) => activity.toJson()).toList(),
    };
  }

  DetailQuotation copyWith({
    int? id,
    String? companyName,
    String? companyWebsite,
    String? phoneNumber,
    String? phoneCode,
    List<String>? typeInformation,
    String? clientSource,
    ClientSource? clientSourceDetail,
    int? status,
    int? priority,
    DateTime? createdAt,
    String? feature,
    String? section,
    String? url,
    List<ClientPic>? clientPic,
    String? cmlabspic,
    List<String>? category,
    AgentData? agent,
    String? email,
    List<ProjectHistory>? activities,
  }) {
    return DetailQuotation(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneCode: phoneCode ?? this.phoneCode,
      typeInformation: typeInformation ?? this.typeInformation,
      clientSource: clientSource ?? this.clientSource,
      clientSourceDetail: clientSourceDetail ?? this.clientSourceDetail,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      feature: feature ?? this.feature,
      section: section ?? this.section,
      url: url ?? this.url,
      clientPic: clientPic ?? this.clientPic,
      cmlabspic: cmlabspic ?? this.cmlabspic,
      category: category ?? this.category,
      agent: agent ?? this.agent,
      email: email ?? this.email,
      activities: activities ?? this.activities,
    );
  }
}
