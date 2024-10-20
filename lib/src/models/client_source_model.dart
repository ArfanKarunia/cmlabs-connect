import 'package:hive/hive.dart';

part 'client_source_model.g.dart';

@HiveType(typeId: 5)
class ClientSource extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  ClientSource({
    required this.id,
    required this.name,
  });

  ClientSource copyWith({
    int? id,
    String? slug,
    String? name,
  }) {
    return ClientSource(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // Serialisasi dari JSON
  factory ClientSource.fromJson(Map<String, dynamic> json) {
    return ClientSource(
      id: json['id'],
      name: json['name'],
    );
  }

  // Serialisasi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

}