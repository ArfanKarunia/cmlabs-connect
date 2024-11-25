// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_changes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryChangesModelAdapter extends TypeAdapter<HistoryChangesModel> {
  @override
  final int typeId = 15;

  @override
  HistoryChangesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryChangesModel(
      id: fields[0] as int,
      requestedId: fields[1] as int,
      name: fields[2] as String,
      type: (fields[3] as List).cast<String?>(),
      note: fields[4] as String?,
      status: fields[5] as int,
      availableToUser: (fields[6] as List).cast<int?>(),
      file: fields[7] as File?,
      createdBy: fields[8] as String,
      createdAtLabel: fields[9] as String,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryChangesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.requestedId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.availableToUser)
      ..writeByte(7)
      ..write(obj.file)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.createdAtLabel)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryChangesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
