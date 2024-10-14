// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      adminRoleId: fields[1] as int,
      rememberToken: fields[2] as String?,
      username: fields[6] as String,
      name: fields[3] as String,
      email: fields[4] as String,
      password: fields[5] as String,
      pic: fields[7] as String?,
      phone: fields[8] as String?,
      jobPosition: fields[9] as String?,
      about: fields[10] as String?,
      aboutEn: fields[11] as String?,
      facebook: fields[12] as String?,
      twitter: fields[13] as String?,
      linkedin: fields[14] as String?,
      instagram: fields[15] as String?,
      medium: fields[16] as String?,
      tiktok: fields[17] as String?,
      quora: fields[18] as String?,
      additionalInformation: fields[19] as String?,
      adminProjectId: fields[20] as int?,
      link: fields[21] as String?,
      adminPositionId: fields[22] as int?,
      picUrl: fields[23] as String?,
      createdAt: fields[24] as DateTime?,
      updatedAt: fields[25] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adminRoleId)
      ..writeByte(2)
      ..write(obj.rememberToken)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.username)
      ..writeByte(7)
      ..write(obj.pic)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.jobPosition)
      ..writeByte(10)
      ..write(obj.about)
      ..writeByte(11)
      ..write(obj.aboutEn)
      ..writeByte(12)
      ..write(obj.facebook)
      ..writeByte(13)
      ..write(obj.twitter)
      ..writeByte(14)
      ..write(obj.linkedin)
      ..writeByte(15)
      ..write(obj.instagram)
      ..writeByte(16)
      ..write(obj.medium)
      ..writeByte(17)
      ..write(obj.tiktok)
      ..writeByte(18)
      ..write(obj.quora)
      ..writeByte(19)
      ..write(obj.additionalInformation)
      ..writeByte(20)
      ..write(obj.adminProjectId)
      ..writeByte(21)
      ..write(obj.link)
      ..writeByte(22)
      ..write(obj.adminPositionId)
      ..writeByte(23)
      ..write(obj.picUrl)
      ..writeByte(24)
      ..write(obj.createdAt)
      ..writeByte(25)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
