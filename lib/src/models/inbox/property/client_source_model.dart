class ClientSource {
  final String? value;
  final String? vendor;
  final String? name;
  final String? contact;

  ClientSource({
    this.value,
    this.vendor,
    this.name,
    this.contact,
  });

  ClientSource copyWith({
    String? value,
    String? vendor,
    String? name,
    String? contact,
  }) {
    return ClientSource(
      value: value ?? this.value,
      vendor: vendor ?? this.vendor,
      name: name ?? this.name,
      contact: contact ?? this.contact,
    );
  }

  factory ClientSource.fromJson(Map<String, dynamic> json) {
    return ClientSource(
      value: json['client_source'],
      vendor: json['client_source_detail']?['vendor'],
      name: json['client_source_detail']?['name'],
      contact: json['client_source_detail']?['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'vendor': vendor,
      'name': name,
      'contact': contact,
    };
  }
}
