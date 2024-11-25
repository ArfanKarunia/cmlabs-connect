import 'package:hive/hive.dart';

part 'client_pic_model.g.dart';

@HiveType(typeId: 4)
class ClientPic {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? position;

  @HiveField(2)
  final List<ContactClientPic?> contacts;

  ClientPic({
    this.name,
    this.position,
    required this.contacts,
  });

  factory ClientPic.fromJson(Map<String, dynamic> json) {
    // Pastikan `contacts` diperlakukan sebagai List<ContactClientPic>
    List<ContactClientPic> contactList = (json['contacts'] as List<dynamic>?)
            ?.map((contact) => ContactClientPic.fromJson(contact))
            .toList() ??
        [];

    return ClientPic(
      name: json['name'],
      position: json['position'],
      contacts: contactList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'contacts': contacts
          .where((contact) => contact?.toJson() != null)
          .map((contact) => contact?.toJson())
          .toList(),
    };
  }

  ClientPic copyWith({
    String? name,
    String? position,
    List<ContactClientPic?>? contacts,
  }) {
    return ClientPic(
      name: name ?? this.name,
      position: position ?? this.position,
      contacts: contacts ?? this.contacts,
    );
  }
}

@HiveType(typeId: 7)
class ContactClientPic {
  @HiveField(0)
  final String? type;

  @HiveField(1)
  final String? info;

  @HiveField(2)
  final String? status;

  @HiveField(3)
  final String? detail;

  @HiveField(4)
  final String? note;

  ContactClientPic({
    this.type,
    this.info,
    this.status,
    this.detail,
    this.note,
  });

  factory ContactClientPic.fromJson(Map<String, dynamic> json) {
    return ContactClientPic(
      type: json['type'],
      info: json['info'],
      status: json['status'],
      detail: json['detail'],
      note: json['note'],
    );
  }

  Map<String, dynamic>? toJson() {
    if (type == null &&
        info == "" &&
        status == null &&
        detail == null &&
        note == "") {
      return null;
    }

    return {
      'type': type,
      'info': info,
      'status': status,
      'detail': detail,
      'note': note,
    };
  }
}
