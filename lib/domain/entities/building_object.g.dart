// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingObjectAdapter extends TypeAdapter<BuildingObject> {
  @override
  final int typeId = 4;

  @override
  BuildingObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingObject(
      objectId: fields[0] as String,
      title: fields[1] as String,
      startDate: fields[2] as DateTime,
      finishDate: fields[3] as DateTime,
      description: fields[4] as String,
      isCompleted: fields[5] as bool,
      photosURL: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BuildingObject obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.finishDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.photosURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
