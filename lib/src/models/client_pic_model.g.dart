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
      contacts: (fields[2] as List).cast<ContactClientPic?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClientPic obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.contacts);
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

class ContactClientPicAdapter extends TypeAdapter<ContactClientPic> {
  @override
  final int typeId = 7;

  @override
  ContactClientPic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactClientPic(
      type: fields[0] as String?,
      info: fields[1] as String?,
      status: fields[2] as String?,
      detail: fields[3] as String?,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactClientPic obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.info)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.detail)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactClientPicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
