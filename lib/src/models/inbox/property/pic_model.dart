class Pic {
  final String value;
  final String label;

  Pic({
    required this.value,
    required this.label,
  });

  factory Pic.fromJson(Map<String, String> json) {
    return Pic(
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
