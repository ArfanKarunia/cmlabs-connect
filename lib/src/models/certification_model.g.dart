// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificationModelAdapter extends TypeAdapter<CertificationModel> {
  @override
  final int typeId = 9;

  @override
  CertificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CertificationModel(
      id: fields[0] as int,
      name: fields[1] as String,
      url: fields[2] as String,
      description: fields[4] as String?,
      pic: fields[5] as String?,
      adminId: fields[8] as int,
      institutionName: fields[3] as String,
      startTime: fields[6] as DateTime,
      finishTime: fields[7] as DateTime?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CertificationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.institutionName)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.pic)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.finishTime)
      ..writeByte(8)
      ..write(obj.adminId)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
