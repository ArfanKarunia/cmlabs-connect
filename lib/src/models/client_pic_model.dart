import 'package:hive/hive.dart';

part 'client_pic_model.g.dart';

@HiveType(typeId: 4)
class ClientPic {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? position;

  ClientPic({
    this.name,
    this.position,
  });

  factory ClientPic.fromJson(Map<String, dynamic> json) {
    return ClientPic(
      name: json['name'],
      position: json['position'],
    );
  }
}