// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 2;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      objectId: fields[0] as String,
      model: fields[1] as String,
      mileage: fields[2] as int,
      vehicleType: fields[8] as int,
      licensePlate: fields[3] as String?,
      description: fields[4] as String?,
      breakageDangerLevel: fields[5] as int,
      hoursInfo: fields[6] as RoutineMaintenanceHoursInfo?,
      imageIdUrl: (fields[7] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.mileage)
      ..writeByte(8)
      ..write(obj.vehicleType)
      ..writeByte(3)
      ..write(obj.licensePlate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.breakageDangerLevel)
      ..writeByte(6)
      ..write(obj.hoursInfo)
      ..writeByte(7)
      ..write(obj.imageIdUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoutineMaintenanceHoursInfoAdapter
    extends TypeAdapter<RoutineMaintenanceHoursInfo> {
  @override
  final int typeId = 3;

  @override
  RoutineMaintenanceHoursInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineMaintenanceHoursInfo(
      periodicity: fields[0] as int,
      engineHoursValue: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineMaintenanceHoursInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.periodicity)
      ..writeByte(1)
      ..write(obj.engineHoursValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineMaintenanceHoursInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
