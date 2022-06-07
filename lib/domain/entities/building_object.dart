import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'building_object.g.dart';

@HiveType(typeId: 4)
class BuildingObject extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime startDate;
  @HiveField(3)
  DateTime finishDate;
  @HiveField(4)
  String description;
  @HiveField(5)
  bool isCompleted;
  @HiveField(6)
  Map<String, String> imagesIdUrl;
  BuildingObject({
    required this.objectId,
    required this.title,
    required this.startDate,
    required this.finishDate,
    required this.description,
    required this.isCompleted,
    required this.imagesIdUrl,
  });

  static BuildingObject getBuildingObject({
    required ParseObject buildingObject,
    required List<ParseObject> imagesList,
  }) {
    final objectId = buildingObject.objectId ?? 'Нет objectId';
    final title = buildingObject.get<String>('title') ?? 'Название не указано';
    final startDate =
        buildingObject.get<DateTime>('startDate') ?? DateTime.now();
    final finishDate =
        buildingObject.get<DateTime>('finishDate') ?? DateTime.now();
    final description = buildingObject.get<String>('description') ??
        'Описание не предоставлено';
    final isCompleted = buildingObject.get<bool>('isCompleted') ?? false;

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

    return BuildingObject(
      objectId: objectId,
      title: title,
      startDate: startDate,
      finishDate: finishDate,
      description: description,
      isCompleted: isCompleted,
      imagesIdUrl: imagesIdUrl,
    );
  }

  void updateBuildingObject(
    String? title,
    DateTime? startDate,
    DateTime? finishDate,
    String? description,
    bool? isCompleted,
    Map<String, String>? imagesIdUrl,
  ) {
    if (title != null) {
      this.title = title;
    }
    if (startDate != null) {
      this.startDate = startDate;
    }
    if (finishDate != null) {
      this.finishDate = finishDate;
    }
    if (description != null) {
      this.description = description;
    }
    if (isCompleted != null) {
      this.isCompleted = isCompleted;
    }
    if (imagesIdUrl != null && imagesIdUrl.isNotEmpty) {
      this.imagesIdUrl.addAll(imagesIdUrl);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BuildingObject &&
        other.objectId == objectId &&
        other.title == title &&
        other.startDate == startDate &&
        other.finishDate == finishDate &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        mapEquals(other.imagesIdUrl, imagesIdUrl);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        startDate.hashCode ^
        finishDate.hashCode ^
        description.hashCode ^
        isCompleted.hashCode ^
        imagesIdUrl.hashCode;
  }
}
