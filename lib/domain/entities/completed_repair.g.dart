// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_repair.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletedRepairAdapter extends TypeAdapter<CompletedRepair> {
  @override
  final int typeId = 7;

  @override
  CompletedRepair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedRepair(
      objectId: fields[0] as String,
      title: fields[1] as String,
      mileage: fields[2] as int,
      description: fields[3] as String,
      date: fields[4] as DateTime,
      vehicleNode: fields[5] as String,
      imagesIdUrl: (fields[6] as Map).cast<String, String>(),
      breakageObjectId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedRepair obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.mileage)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.vehicleNode)
      ..writeByte(6)
      ..write(obj.imagesIdUrl)
      ..writeByte(7)
      ..write(obj.breakageObjectId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedRepairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
