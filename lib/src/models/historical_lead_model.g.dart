// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_lead_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoricalLeadModelAdapter extends TypeAdapter<HistoricalLeadModel> {
  @override
  final int typeId = 7;

  @override
  HistoricalLeadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoricalLeadModel(
      total: fields[0] as int,
      formUser: fields[1] as int,
      googleAds: fields[2] as int,
      metaAds: fields[3] as int,
      marketing: fields[4] as int,
      id: (fields[5] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistoricalLeadModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.total)
      ..writeByte(1)
      ..write(obj.formUser)
      ..writeByte(2)
      ..write(obj.googleAds)
      ..writeByte(3)
      ..write(obj.metaAds)
      ..writeByte(4)
      ..write(obj.marketing)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoricalLeadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
