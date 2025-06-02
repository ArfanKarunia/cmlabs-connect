import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:cmlabs_connect/src/models/client_source_model.dart';
import 'package:flutter/material.dart';

class Quotation {
  final int id;
  final int? userId;
  final String feature;
  final String url;
  final String email;
  final QuotationData data;
  final AgentData? agent;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? section;
  final int priority;
  final int status;
  final DateTime? deletedAt;

  Quotation({
    required this.id,
    this.userId,
    this.feature = "-",
    this.url = "-",
    this.email = "-",
    required this.data,
    this.agent,
    required this.createdAt,
    required this.updatedAt,
    this.section,
    required this.priority,
    required this.status,
    this.deletedAt,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      feature: json['feature'],
      url: json['url'] ?? '-',
      email: json['email'] ?? "-",
      data: QuotationData.fromJson(json['data']),
      agent: json['agent'] != null ? AgentData.fromJson(json['agent']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      section: json['section'] ?? '-',
      priority: json['priority'] ?? 0,
      status: json['status'] ?? 0,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'feature': feature,
      'url': url,
      'email': email,
      'data': data.toJson(),
      'agent': agent?.toJson(), // Cek jika agent null
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'section': section,
      'priority': priority,
      'status': status,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class QuotationData {
  final String? language;
  final String? name;
  final String? phoneCode;
  final String? phoneNumber;
  final String? company;
  final String? companyIndustry;
  final List<String?> category;
  final dynamic registrationStatus;
  final String? website;
  final String? region;
  final List<String?> type;
  final String? pic;
  final List<ClientPic?> clientPIC;
  final String? remarks;
  final String? notes;
  final List<String?> meetingTopic;
  final List<DateTime?> meetingSchedule;
  final List<String?> meetingStatus;
  final List<String?> meetingNote;
  final String? addtionalNotes;
  final DateTime? meetingAppointment;
  final String? message;
  final List<List<String>?> meetingType;
  final ClientSource? clientSource;

  QuotationData({
    this.language,
    this.name,
    this.phoneCode,
    this.phoneNumber,
    this.company,
    this.companyIndustry,
    this.registrationStatus,
    this.website,
    this.region,
    required this.type,
    required this.category,
    required this.clientPIC, // List<ClientPic>
    this.pic,
    this.remarks,
    this.notes,
    required this.meetingTopic,
    required this.meetingSchedule,
    required this.meetingStatus,
    required this.meetingNote,
    this.addtionalNotes,
    this.meetingAppointment,
    this.message,
    required this.meetingType,
    this.clientSource,
  });

  factory QuotationData.fromJson(Map<String, dynamic> json) {
    try {
      // Parsing client_pic menjadi List<ClientPic>
      List<ClientPic> clientPics = [];
      if (json['client_pic'] is List) {
        clientPics =
            (json['client_pic'] as List<dynamic>?)?.map((picJson) => ClientPic.fromJson(picJson)).toList() ?? [];
      } else if (json['client_pic'] is Map) {
        clientPics = (json['client_pic'] as Map<String, dynamic>?)
                ?.values
                .map((picJson) => ClientPic.fromJson(picJson))
                .toList() ??
            [];
      }

      // Parsing data meeting lainnya tetap sama
      List<String?> meetingTopics =
          (json['meeting_topic'] as List<dynamic>?)?.map((topic) => topic.toString()).toList() ?? [];

      List<DateTime?> meetingSchedules = (json['meeting_schedule'] as List<dynamic>?)
              ?.map((schedule) => DateTime.tryParse(schedule.toString()))
              .toList() ??
          [];

      List<String?> meetingStatuses =
          (json['meeting_status'] as List<dynamic>?)?.map((status) => status.toString()).toList() ?? [];

      List<String?> meetingNotes =
          (json['meeting_note'] as List<dynamic>?)?.map((note) => note.toString()).toList() ?? [];

      List<List<String>> meetingTypes = [];
      if (json['meeting_type'] != null && json['meeting_type'] is List) {
        meetingTypes = (json['meeting_type'] as List<dynamic>).map((type) => List<String>.from(type as List)).toList();
      }

      // Handle 'type' yang mungkin null, String, atau List
      List<String> types = [];
      if (json['type'] != null) {
        if (json['type'] is String) {
          types = [json['type']];
        } else if (json['type'] is List) {
          // Check if the list contains only null values
          if (json['type'].every((element) => element == null)) {
            types = []; // Set to empty list if all elements are null
          } else {
            types = List<String>.from(json['type'].where((element) => element != null)); // Filter out nulls
          }
        }
      }

      // Handle category yang mungkin berupa String atau List
      List<String> categories = [];
      if (json['category'] != null) {
        if (json['category'] is String) {
          categories = [json['category']];
        } else if (json['category'] is List) {
          categories = List<String>.from(json['category']);
        }
      }

      return QuotationData(
        language: json['language'] ?? '-',
        name: json['name'] ?? '-',
        phoneCode: json['phone_code'] ?? '-',
        phoneNumber: json['phone_number'] ?? '-',
        company: json['company_name'] ?? json['company'] ?? '-',
        companyIndustry: json['company_industry'] ?? '-',
        registrationStatus: json['registration-status'] ?? '-',
        website: json['website'] ?? '-',
        region: json['region'] ?? '-',
        type: types,
        category: categories,
        clientPIC: clientPics, // Menggunakan List<ClientPic>
        pic: json['pic'] ?? '-',
        remarks: json['remarks'] ?? '-',
        notes: json['notes'] ?? '-',
        meetingTopic: meetingTopics,
        meetingSchedule: meetingSchedules,
        meetingStatus: meetingStatuses,
        meetingNote: meetingNotes,
        addtionalNotes: json['meeting'] ?? '-',
        meetingType: meetingTypes,
        clientSource: ClientSource.fromJson(
          {'client_source': json['client_source'], ...?json['client_source_detail']},
        ),
      );
    } catch (e, stacktrace) {
      // Cetak error dan stack trace untuk melacak lebih jelas
      debugPrint("Error in QuotationData.fromJson: $e");
      debugPrint("Stacktrace: $stacktrace");
      return QuotationData(
        language: '',
        name: '',
        phoneCode: '',
        phoneNumber: '',
        company: '',
        companyIndustry: '',
        registrationStatus: '',
        website: '',
        region: '',
        type: [],
        category: [], // default kosong
        clientPIC: [], // default kosong
        pic: '',
        remarks: '',
        notes: '',
        meetingTopic: [],
        meetingSchedule: [],
        meetingStatus: [],
        meetingNote: [],
        addtionalNotes: '',
        meetingType: [],
        clientSource: null, // Fallback ke data kosong
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'name': name,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'company': company,
      'company_industry': companyIndustry,
      'registration-status': registrationStatus,
      'website': website,
      'region': region,
      'type': type,
      'category': category,
      'client_pic': clientPIC, // Ubah ini sesuai struktur ClientPic
      'remarks': remarks,
      'notes': notes,
      'meeting_topic': meetingTopic,
      'meeting_schedule': meetingSchedule.map((schedule) => schedule?.toIso8601String()).toList(),
      'meeting_status': meetingStatus,
      'meeting_note': meetingNote,
      'meeting': addtionalNotes,
      'meeting_type': meetingType,
      'client_source': clientSource?.toJson()
    };
  }
}

class AgentData {
  final String? browser;
  final String? device;
  final String? ip;
  final List<String?> language;
  final String? platform;
  final String? devices;

  AgentData({
    this.browser,
    this.device,
    this.ip,
    required this.language,
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
    } catch (e, stacktrace) {
      debugPrint("Error in AgentData.fromJson: $e");
      debugPrint("Stacktrace: $stacktrace");
      return AgentData(
        browser: null,
        device: null,
        ip: null,
        language: [],
        platform: null,
        devices: null,
      );
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
