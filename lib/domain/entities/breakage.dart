import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'breakage.g.dart';

@HiveType(typeId: 1)
class Breakage extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String vehicleNode;
  @HiveField(3)
  int dangerLevel;
  @HiveField(4)
  String description;
  @HiveField(5)
  bool isFixed;
  @HiveField(6)
  Map<String, String> imagesIdUrl;
  Breakage({
    required this.objectId,
    required this.title,
    required this.vehicleNode,
    required this.dangerLevel,
    required this.description,
    required this.isFixed,
    required this.imagesIdUrl,
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
    Map<String, String> imagesIdUrl = {};
    for (var imageParseObject in imagesList) {
      final imageId = imageParseObject.objectId;
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageId != null && imageURL != null) {
        imagesIdUrl[imageId] = imageURL;
      }
    }

    return Breakage(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      dangerLevel: dangerLevel,
      description: description,
      isFixed: isFixed,
      imagesIdUrl: imagesIdUrl,
    );
  }

  void updateBreakage(
    String? title,
    String? vehicleNode,
    int? dangerLevel,
    String? description,
    bool? isFixed,
    Map<String, String>? imagesIdUrl,
  ) {
    if (title != null) {
      this.title = title;
    }
    if (vehicleNode != null) {
      this.vehicleNode = vehicleNode;
    }
    if (dangerLevel != null) {
      this.dangerLevel = dangerLevel;
    }
    if (description != null) {
      this.description = description;
    }
    if (isFixed != null) {
      this.isFixed = isFixed;
    }
    if (imagesIdUrl != null && imagesIdUrl.isNotEmpty) {
      this.imagesIdUrl.addAll(imagesIdUrl);
    }
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
      mapEquals(other.imagesIdUrl, imagesIdUrl);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
      title.hashCode ^
      vehicleNode.hashCode ^
      dangerLevel.hashCode ^
      description.hashCode ^
      isFixed.hashCode ^
      imagesIdUrl.hashCode;
  }
}
