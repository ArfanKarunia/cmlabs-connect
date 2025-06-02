class User {
  final int id;
  final int adminRoleId;
  final String? roleName;
  final String? rememberToken;
  final String name;
  final String email;
  final String password;
  final String username;
  final String? pic;
  final String? phone;
  final String? jobPosition;
  final String? about;
  final String? aboutEn;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final String? medium;
  final String? tiktok;
  final String? quora;
  final String? additionalInformation;
  final int? adminProjectId;
  final String? link;
  final int? adminPositionId;
  final String? picUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.adminRoleId,
    this.roleName = "User",
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
      roleName: map['role_name'],
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
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  // Fungsi untuk convert ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adminRoleId': adminRoleId,
      'roleName': roleName,
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
