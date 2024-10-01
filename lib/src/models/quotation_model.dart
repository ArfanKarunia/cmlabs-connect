import 'package:hive/hive.dart';
import 'package:quotation_app/src/constant/const.dart';

part 'quotation_model.g.dart';

@HiveType(typeId: 0)
class Quotation extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime joinedAt;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final List<String>? category;

  @HiveField(4)
  final String? clientSource;

  @HiveField(5)
  final String? name;

  @HiveField(6)
  final String? email;

  @HiveField(7)
  final String? whatsappNumber;

  @HiveField(8)
  final String? companyWebsite;

  @HiveField(9)
  final String? companyName;

  @HiveField(10)
  final String? companyProfile;

  @HiveField(11)
  final String? pageSource;

  @HiveField(12)
  final List<String>? service;

  @HiveField(13)
  final String? package;

  @HiveField(14)
  final String? language;

  @HiveField(15)
  final String? region;

  @HiveField(16)
  final String? pic;

  @HiveField(17)
  final StatusLead statusLead;

  Quotation({
    required this.id,
    required this.joinedAt,
    required this.status,
    this.category,
    this.clientSource,
    this.name,
    this.email,
    this.whatsappNumber,
    this.companyWebsite,
    this.companyName,
    this.companyProfile,
    this.pageSource,
    this.service,
    this.package,
    this.language,
    this.region,
    this.pic,
    required this.statusLead,
  });

  // Method untuk copy object dan update value tertentu

  Quotation copyWith({
    int? id,
    DateTime? joinedAt,
    String? status,
    List<String>? category,
    String? clientSource,
    String? name,
    String? email,
    String? whatsappNumber,
    String? companyWebsite,
    String? companyName,
    String? companyProfile,
    String? pageSource,
    List<String>? service,
    String? package,
    String? language,
    String? region,
    String? pic,
    Enum? statusLead,
  }) {
    return Quotation(
      id: id ?? this.id,
      joinedAt: joinedAt ?? this.joinedAt,
      status: status ?? this.status,
      category: category ?? this.category,
      clientSource: clientSource ?? this.clientSource,
      name: name ?? this.name,
      email: email ?? this.email,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyName: companyName ?? this.companyName,
      companyProfile: companyProfile ?? this.companyProfile,
      pageSource: pageSource ?? this.pageSource,
      service: service ?? this.service,
      package: package ?? this.package,
      language: language ?? this.language,
      region: region ?? this.region,
      pic: pic ?? this.pic,
      statusLead: this.statusLead,
    );
  }

  // Serialisasi dari JSON
  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      joinedAt: DateTime.parse(json['joinedAt']),
      status: json['status'],
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      clientSource: json['clientSource'],
      name: json['name'],
      email: json['email'],
      whatsappNumber: json['whatsappNumber'],
      companyWebsite: json['companyWebsite'],
      companyName: json['companyName'],
      companyProfile: json['companyProfile'],
      pageSource: json['pageSource'],
      service:
          (json['service'] as List<dynamic>?)?.map((e) => e as String).toList(),
      package: json['package'],
      language: json['language'],
      region: json['region'],
      pic: json['pic'],
      statusLead: json['statusLead'],
    );
  }

  // Serialisasi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'joinedAt': joinedAt.toIso8601String(),
      'status': status,
      'category': category,
      'clientSource': clientSource,
      'name': name,
      'email': email,
      'whatsappNumber': whatsappNumber,
      'companyWebsite': companyWebsite,
      'companyName': companyName,
      'companyProfile': companyProfile,
      'pageSource': pageSource,
      'service': service,
      'package': package,
      'language': language,
      'region': region,
      'pic': pic,
      'statusLead': statusLead,
    };
  }
}
