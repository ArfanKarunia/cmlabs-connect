import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 6)
class Category extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String slug;

  @HiveField(2)
  final String name;

  Category({
    required this.id,
    required this.slug,
    required this.name,
  });

  Category copyWith({
    int? id,
    String? slug,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
    );
  }

  // Serialisasi dari JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
    );
  }

  // Serialisasi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
    };
  }
}

