class ClientPic {
  final String? name;
  final String? position;
  final List<ContactClientPic> contacts;

  ClientPic({
    this.name,
    this.position,
    required this.contacts,
  });

  factory ClientPic.fromJson(Map<String, dynamic> json) {
    final List<ContactClientPic> contactList =
        (json['contacts'] as List<dynamic>?)?.map((contact) => ContactClientPic.fromJson(contact)).toList() ?? [];

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
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
  }

  ClientPic copyWith({
    String? name,
    String? position,
    List<ContactClientPic>? contacts,
  }) {
    return ClientPic(
      name: name ?? this.name,
      position: position ?? this.position,
      contacts: contacts ?? this.contacts,
    );
  }
}

class ContactClientPic {
  String? type;
  String? info;
  String? status;
  String? detail;
  String? note;

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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'info': info,
      'status': status,
      'detail': detail,
      'note': note,
    };
  }

  ContactClientPic copyWith({
    String? type,
    String? info,
    String? status,
    String? detail,
    String? note,
  }) {
    return ContactClientPic(
      type: type ?? this.type,
      info: info ?? this.info,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      note: note ?? this.note,
    );
  }
}
