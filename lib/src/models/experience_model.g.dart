// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExperienceModelAdapter extends TypeAdapter<ExperienceModel> {
  @override
  final int typeId = 8;

  @override
  ExperienceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExperienceModel(
      id: fields[0] as int,
      position: fields[1] as String,
      company: fields[2] as String,
      type: fields[3] as String,
      startTime: fields[4] as DateTime,
      finishTime: fields[5] as DateTime?,
      description: fields[6] as String,
      adminId: fields[7] as int,
      projectId: fields[8] as int?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ExperienceModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.finishTime)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.adminId)
      ..writeByte(8)
      ..write(obj.projectId)
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
      other is ExperienceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
