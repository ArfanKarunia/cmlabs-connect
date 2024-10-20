// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      adminRoleId: fields[1] as int,
      roleName: fields[2] as String?,
      rememberToken: fields[3] as String?,
      username: fields[7] as String,
      name: fields[4] as String,
      email: fields[5] as String,
      password: fields[6] as String,
      pic: fields[8] as String?,
      phone: fields[9] as String?,
      jobPosition: fields[10] as String?,
      about: fields[11] as String?,
      aboutEn: fields[12] as String?,
      facebook: fields[13] as String?,
      twitter: fields[14] as String?,
      linkedin: fields[15] as String?,
      instagram: fields[16] as String?,
      medium: fields[17] as String?,
      tiktok: fields[18] as String?,
      quora: fields[19] as String?,
      additionalInformation: fields[20] as String?,
      adminProjectId: fields[21] as int?,
      link: fields[22] as String?,
      adminPositionId: fields[23] as int?,
      picUrl: fields[24] as String?,
      createdAt: fields[25] as DateTime?,
      updatedAt: fields[26] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adminRoleId)
      ..writeByte(2)
      ..write(obj.roleName)
      ..writeByte(3)
      ..write(obj.rememberToken)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.username)
      ..writeByte(8)
      ..write(obj.pic)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.jobPosition)
      ..writeByte(11)
      ..write(obj.about)
      ..writeByte(12)
      ..write(obj.aboutEn)
      ..writeByte(13)
      ..write(obj.facebook)
      ..writeByte(14)
      ..write(obj.twitter)
      ..writeByte(15)
      ..write(obj.linkedin)
      ..writeByte(16)
      ..write(obj.instagram)
      ..writeByte(17)
      ..write(obj.medium)
      ..writeByte(18)
      ..write(obj.tiktok)
      ..writeByte(19)
      ..write(obj.quora)
      ..writeByte(20)
      ..write(obj.additionalInformation)
      ..writeByte(21)
      ..write(obj.adminProjectId)
      ..writeByte(22)
      ..write(obj.link)
      ..writeByte(23)
      ..write(obj.adminPositionId)
      ..writeByte(24)
      ..write(obj.picUrl)
      ..writeByte(25)
      ..write(obj.createdAt)
      ..writeByte(26)
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
