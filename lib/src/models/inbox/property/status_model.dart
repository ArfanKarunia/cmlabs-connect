class Status {
  final String value;
  final String label;

  Status({
    required this.value,
    required this.label,
  });

  factory Status.fromJson(Map<String, String> json) {
    return Status(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
