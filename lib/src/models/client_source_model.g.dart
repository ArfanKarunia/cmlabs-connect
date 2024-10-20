// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_source_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientSourceAdapter extends TypeAdapter<ClientSource> {
  @override
  final int typeId = 5;

  @override
  ClientSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientSource(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientSource obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
