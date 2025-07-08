class Category {
  final String value;
  final String label;

  Category({
    required this.value,
    required this.label,
  });

  factory Category.fromJson(Map<String, String> json) {
    return Category(
      value: json['id'].toString(),
      label: json['text'].toString(),
    );
  }

  Map<String, String> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
