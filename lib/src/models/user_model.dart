import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int adminRoleId;

  @HiveField(2)
  final String? rememberToken;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String username;

  @HiveField(7)
  final String? pic;

  @HiveField(8)
  final String? phone;

  @HiveField(9)
  final String? jobPosition;

  @HiveField(10)
  final String? about;

  @HiveField(11)
  final String? aboutEn;

  @HiveField(12)
  final String? facebook;

  @HiveField(13)
  final String? twitter;

  @HiveField(14)
  final String? linkedin;

  @HiveField(15)
  final String? instagram;

  @HiveField(16)
  final String? medium;

  @HiveField(17)
  final String? tiktok;

  @HiveField(18)
  final String? quora;

  @HiveField(19)
  final String? additionalInformation;

  @HiveField(20)
  final int? adminProjectId;

  @HiveField(21)
  final String? link;

  @HiveField(22)
  final int? adminPositionId;

  @HiveField(23)
  final String? picUrl;

  @HiveField(24)
  final DateTime? createdAt;

  @HiveField(25)
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.adminRoleId,
    this.rememberToken,
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    this.pic,
    this.phone,
    this.jobPosition,
    this.about,
    this.aboutEn,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.medium,
    this.tiktok,
    this.quora,
    this.additionalInformation,
    this.adminProjectId,
    this.link,
    this.adminPositionId,
    this.picUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Fungsi untuk convert dari Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      adminRoleId: map['admin_role_id'],
      rememberToken: map['remember_token'],
      username: map['username'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      pic: map['pic'],
      phone: map['phone'],
      jobPosition: map['job_position'],
      about: map['about'],
      aboutEn: map['about_en'],
      facebook: map['facebook'],
      twitter: map['twitter'],
      linkedin: map['linkedin'],
      instagram: map['instagram'],
      medium: map['medium'],
      tiktok: map['tiktok'],
      quora: map['quora'],
      additionalInformation: map['additional_information'],
      adminProjectId: map['admin_project_id'],
      link: map['link'],
      adminPositionId: map['admin_position_id'],
      picUrl: map['pic_url'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  // Fungsi untuk convert ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adminRoleId': adminRoleId,
      'rememberToken': rememberToken,
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'pic': pic,
      'phone': phone,
      'jobPosition': jobPosition,
      'about': about,
      'aboutEn': aboutEn,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      'instagram': instagram,
      'medium': medium,
      'tiktok': tiktok,
      'quora': quora,
      'additionalInformation': additionalInformation,
      'adminProjectId': adminProjectId,
      'link': link,
      'adminPositionId': adminPositionId,
      'picUrl': picUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
