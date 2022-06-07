// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreakageAdapter extends TypeAdapter<Breakage> {
  @override
  final int typeId = 1;

  @override
  Breakage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Breakage(
      objectId: fields[0] as String,
      title: fields[1] as String,
      vehicleNode: fields[2] as String,
      dangerLevel: fields[3] as int,
      description: fields[4] as String,
      isFixed: fields[5] as bool,
      imagesIdUrl: (fields[6] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Breakage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.vehicleNode)
      ..writeByte(3)
      ..write(obj.dangerLevel)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isFixed)
      ..writeByte(6)
      ..write(obj.imagesIdUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
