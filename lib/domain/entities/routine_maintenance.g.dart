// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_maintenance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineMaintenanceAdapter extends TypeAdapter<RoutineMaintenance> {
  @override
  final int typeId = 8;

  @override
  RoutineMaintenance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineMaintenance(
      objectId: fields[0] as String,
      title: fields[1] as String,
      periodicity: fields[2] as int,
      engineHoursValue: fields[3] as int,
      vehicleNode: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineMaintenance obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.periodicity)
      ..writeByte(3)
      ..write(obj.engineHoursValue)
      ..writeByte(4)
      ..write(obj.vehicleNode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineMaintenanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
