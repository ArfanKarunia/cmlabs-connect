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
      userId: fields[1] as int?,
      feature: fields[2] as String,
      url: fields[3] as String,
      email: fields[4] as String,
      data: fields[5] as QuotationData,
      agent: fields[6] as AgentData?,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
      section: fields[9] as String?,
      priority: fields[10] as int,
      status: fields[11] as int,
      deletedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Quotation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.feature)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.agent)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.section)
      ..writeByte(10)
      ..write(obj.priority)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.deletedAt);
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

class QuotationDataAdapter extends TypeAdapter<QuotationData> {
  @override
  final int typeId = 1;

  @override
  QuotationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotationData(
      language: fields[0] as String?,
      name: fields[1] as String?,
      phoneCode: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      company: fields[4] as String?,
      companyIndustry: fields[5] as String?,
      registrationStatus: fields[6] as dynamic,
      website: fields[7] as String?,
      region: fields[8] as String?,
      type: (fields[9] as List).cast<String?>(),
      category: (fields[10] as List).cast<String?>(),
      clientPIC: (fields[11] as List).cast<ClientPic?>(),
      pic: fields[12] as String?,
      remarks: fields[13] as String?,
      notes: fields[14] as String?,
      meetingTopic: (fields[15] as List).cast<String?>(),
      meetingSchedule: (fields[16] as List).cast<DateTime?>(),
      meetingStatus: (fields[17] as List).cast<String?>(),
      meetingNote: (fields[18] as List).cast<String?>(),
      meeting: fields[19] as String?,
      meetingAppointment: fields[20] as DateTime?,
      message: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuotationData obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneCode)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.companyIndustry)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.registrationStatus)
      ..writeByte(7)
      ..write(obj.website)
      ..writeByte(8)
      ..write(obj.region)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.pic)
      ..writeByte(11)
      ..write(obj.clientPIC)
      ..writeByte(13)
      ..write(obj.remarks)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.meetingTopic)
      ..writeByte(16)
      ..write(obj.meetingSchedule)
      ..writeByte(17)
      ..write(obj.meetingStatus)
      ..writeByte(18)
      ..write(obj.meetingNote)
      ..writeByte(19)
      ..write(obj.meeting)
      ..writeByte(20)
      ..write(obj.meetingAppointment)
      ..writeByte(21)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentDataAdapter extends TypeAdapter<AgentData> {
  @override
  final int typeId = 2;

  @override
  AgentData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentData(
      browser: fields[0] as String?,
      device: fields[1] as String?,
      ip: fields[2] as String?,
      language: (fields[3] as List).cast<String?>(),
      platform: fields[4] as String?,
      devices: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AgentData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.browser)
      ..writeByte(1)
      ..write(obj.device)
      ..writeByte(2)
      ..write(obj.ip)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.platform)
      ..writeByte(5)
      ..write(obj.devices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
