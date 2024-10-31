import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:cmlabs_connect/src/models/client_source_model.dart';
import 'package:hive/hive.dart';

part 'quotation_model.g.dart';

@HiveType(typeId: 0)
class Quotation extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? userId;

  @HiveField(2)
  final String feature;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final QuotationData data;

  @HiveField(6)
  final AgentData? agent;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final String? section;

  @HiveField(10)
  final int priority;

  @HiveField(11)
  final int status;

  @HiveField(12)
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
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      feature: json['feature'],
      url: json['url'],
      email: json['email'] ?? "-",
      data: QuotationData.fromJson(json['data']),
      agent: json['agent'] != null ? AgentData.fromJson(json['agent']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      section: json['section'],
      priority: json['priority'],
      status: json['status'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
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

@HiveType(typeId: 1)
class QuotationData {
  @HiveField(0)
  final String? language;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? phoneCode;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? company;

  @HiveField(5)
  final String? companyIndustry;

  @HiveField(10)
  final List<String?> category;

  @HiveField(6)
  final dynamic registrationStatus;

  @HiveField(7)
  final String? website;

  @HiveField(8)
  final String? region;

  @HiveField(9)
  final List<String?> type;

  @HiveField(12)
  final String? pic;

  @HiveField(11)
  final List<ClientPic?> clientPIC; // Menggunakan List<ClientPic>

  @HiveField(13)
  final String? remarks;

  @HiveField(14)
  final String? notes;

  @HiveField(15)
  final List<String?> meetingTopic;

  @HiveField(16)
  final List<DateTime?> meetingSchedule;

  @HiveField(17)
  final List<String?> meetingStatus;

  @HiveField(18)
  final List<String?> meetingNote;

  @HiveField(19)
  final String? meeting;

  @HiveField(20)
  final DateTime? meetingAppointment;

  @HiveField(21)
  final String? message;

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
    this.meeting,
    this.meetingAppointment,
    this.message,
    this.clientSource,
  });

  factory QuotationData.fromJson(Map<String, dynamic> json) {
    try {
      // Parsing client_pic menjadi List<ClientPic>
      List<ClientPic> clientPics = (json['client_pic'] as List<dynamic>?)
              ?.map((picJson) => ClientPic.fromJson(picJson))
              .toList() ??
          [];

      // Parsing data meeting lainnya tetap sama
      List<String?> meetingTopics = (json['meeting_topic'] as List<dynamic>?)
              ?.map((topic) => topic.toString())
              .toList() ??
          [];

      List<DateTime?> meetingSchedules =
          (json['meeting_schedule'] as List<dynamic>?)
                  ?.map((schedule) => DateTime.tryParse(schedule.toString()))
                  .toList() ??
              [];

      List<String?> meetingStatuses = (json['meeting_status'] as List<dynamic>?)
              ?.map((status) => status.toString())
              .toList() ??
          [];

      List<String?> meetingNotes = (json['meeting_note'] as List<dynamic>?)
              ?.map((note) => note.toString())
              .toList() ??
          [];

      // Handle 'type' yang mungkin null, String, atau List
      List<String> types = [];
      if (json['type'] != null) {
        if (json['type'] is String) {
          types = [json['type']];
        } else if (json['type'] is List) {
          types = List<String>.from(json['type']);
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
        language: json['language'],
        name: json['name'],
        phoneCode: json['phone_code'],
        phoneNumber: json['phone_number'],
        company: json['company'],
        companyIndustry: json['company_industry'],
        registrationStatus: json['registration-status'],
        website: json['website'],
        region: json['region'],
        type: types,
        category: categories,
        clientPIC: clientPics, // Menggunakan List<ClientPic>
        pic: json['pic'],
        remarks: json['remarks'],
        notes: json['notes'],
        meetingTopic: meetingTopics,
        meetingSchedule: meetingSchedules,
        meetingStatus: meetingStatuses,
        meetingNote: meetingNotes,
        meeting: json['meeting'],
        clientSource: ClientSource.fromJson(
          {
            'client_source': json['client_source'],
            ...?json['client_source_detail']
          },
        ),
      );
    } catch (e, stacktrace) {
      // Cetak error dan stack trace untuk melacak lebih jelas
      print("Error in QuotationData.fromJson: $e");
      print("Stacktrace: $stacktrace");
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
          meeting: '',
          clientSource: null); // Fallback ke data kosong
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
      'meeting_schedule': meetingSchedule
          .map((schedule) => schedule?.toIso8601String())
          .toList(),
      'meeting_status': meetingStatus,
      'meeting_note': meetingNote,
      'meeting': meeting,
      'client_source': clientSource?.toJson()
    };
  }
}

@HiveType(typeId: 2)
class AgentData {
  @HiveField(0)
  final String? browser;
  @HiveField(1)
  final String? device;
  @HiveField(2)
  final String? ip;
  @HiveField(3)
  final List<String?> language;
  @HiveField(4)
  final String? platform;
  @HiveField(5)
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
        language: json['language'] is String
            ? [json['language']]
            : List<String>.from(json['language'] ?? []),
        platform: json['platform'] is String ? json['platform'] : null,
        devices: json['devices'] is String ? json['devices'] : null,
      );
    } catch (e, stacktrace) {
      print("Error in AgentData.fromJson: $e");
      print("Stacktrace: $stacktrace");
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

