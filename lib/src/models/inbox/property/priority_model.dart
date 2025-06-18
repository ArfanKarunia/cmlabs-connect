class Priority {
  final String value;
  final String label;

  Priority({
    required this.value,
    required this.label,
  });

  factory Priority.fromJson(Map<String, String> json) {
    return Priority(
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
