// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationAdapter extends TypeAdapter<Recommendation> {
  @override
  final int typeId = 6;

  @override
  Recommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recommendation(
      objectId: fields[0] as String,
      title: fields[1] as String,
      vehicleNode: fields[2] as String,
      description: fields[3] as String,
      isCompleted: fields[4] as bool,
      photosURL: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recommendation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.vehicleNode)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.photosURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
