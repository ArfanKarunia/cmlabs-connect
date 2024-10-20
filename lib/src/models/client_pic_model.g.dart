// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_pic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientPicAdapter extends TypeAdapter<ClientPic> {
  @override
  final int typeId = 4;

  @override
  ClientPic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientPic(
      name: fields[0] as String?,
      position: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientPic obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientPicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
