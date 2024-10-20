// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardDataAdapter extends TypeAdapter<DashboardData> {
  @override
  final int typeId = 4;

  @override
  DashboardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardData(
      amountNewLeads: fields[0] as int,
      amountAcceptedLeads: fields[2] as int,
      amountFollowedupLeads: fields[3] as int,
      amountLast30Days: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amountNewLeads)
      ..writeByte(1)
      ..write(obj.amountLast30Days)
      ..writeByte(2)
      ..write(obj.amountAcceptedLeads)
      ..writeByte(3)
      ..write(obj.amountFollowedupLeads);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
