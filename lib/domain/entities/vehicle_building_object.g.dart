// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_building_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleBuildingObjectAdapter extends TypeAdapter<VehicleBuildingObject> {
  @override
  final int typeId = 5;

  @override
  VehicleBuildingObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleBuildingObject(
      id: fields[0] as String,
      buildingObjectId: fields[1] as String,
      vehicleId: fields[2] as String,
      requiredEngineHours: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleBuildingObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.buildingObjectId)
      ..writeByte(2)
      ..write(obj.vehicleId)
      ..writeByte(3)
      ..write(obj.requiredEngineHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleBuildingObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
