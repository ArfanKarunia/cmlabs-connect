// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationAdapter extends TypeAdapter<Quotation> {
  @override
  final int typeId = 0;

  @override
  Quotation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quotation(
      id: fields[0] as int,
      joinedAt: fields[1] as DateTime,
      status: fields[2] as String,
      category: (fields[3] as List?)?.cast<String>(),
      clientSource: fields[4] as String?,
      name: fields[5] as String?,
      email: fields[6] as String?,
      whatsappNumber: fields[7] as String?,
      companyWebsite: fields[8] as String?,
      companyName: fields[9] as String?,
      companyProfile: fields[10] as String?,
      pageSource: fields[11] as String?,
      service: (fields[12] as List?)?.cast<String>(),
      package: fields[13] as String?,
      language: fields[14] as String?,
      region: fields[15] as String?,
      pic: fields[16] as String?,
      statusLead: fields[17] as StatusLead,
    );
  }

  @override
  void write(BinaryWriter writer, Quotation obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.joinedAt)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.clientSource)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.whatsappNumber)
      ..writeByte(8)
      ..write(obj.companyWebsite)
      ..writeByte(9)
      ..write(obj.companyName)
      ..writeByte(10)
      ..write(obj.companyProfile)
      ..writeByte(11)
      ..write(obj.pageSource)
      ..writeByte(12)
      ..write(obj.service)
      ..writeByte(13)
      ..write(obj.package)
      ..writeByte(14)
      ..write(obj.language)
      ..writeByte(15)
      ..write(obj.region)
      ..writeByte(16)
      ..write(obj.pic)
      ..writeByte(17)
      ..write(obj.statusLead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
