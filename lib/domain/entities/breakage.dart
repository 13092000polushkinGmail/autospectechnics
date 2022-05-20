import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'breakage.g.dart';

@HiveType(typeId: 1)
class Breakage extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String vehicleNode;
  @HiveField(3)
  final int dangerLevel;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final bool isFixed;
  @HiveField(6)
  final List<String> photosURL;
  Breakage({
    required this.objectId,
    required this.title,
    required this.vehicleNode,
    required this.dangerLevel,
    required this.description,
    required this.isFixed,
    required this.photosURL,
  });

  static Breakage getBreakage({
    required ParseObject breakageObject,
    required List<ParseObject> imagesList,
  }) {
    final objectId = breakageObject.objectId ?? 'Нет objectId';
    final title = breakageObject.get<String>('title') ?? 'Название не указано';
    final vehicleNode = breakageObject.get<String>('vehicleNode') ??
        'Узел автомобиля не указан';
    final dangerLevel = breakageObject.get<int>('dangerLevel') ?? -1;
    final description = breakageObject.get<String>('description') ??
        'Описание не предоставлено';
    final isFixed = breakageObject.get<bool>('isFixed') ?? false;
    List<String> photosURL = [];
    for (var imageParseObject in imagesList) {
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageURL != null) {
        photosURL.add(imageURL);
      }
    }

    return Breakage(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      dangerLevel: dangerLevel,
      description: description,
      isFixed: isFixed,
      photosURL: photosURL,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Breakage &&
        other.objectId == objectId &&
        other.title == title &&
        other.vehicleNode == vehicleNode &&
        other.dangerLevel == dangerLevel &&
        other.description == description &&
        other.isFixed == isFixed &&
        listEquals(other.photosURL, photosURL);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        vehicleNode.hashCode ^
        dangerLevel.hashCode ^
        description.hashCode ^
        isFixed.hashCode ^
        photosURL.hashCode;
  }
}
