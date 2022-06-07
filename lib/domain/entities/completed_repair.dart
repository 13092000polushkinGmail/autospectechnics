import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'completed_repair.g.dart';

@HiveType(typeId: 7)
class CompletedRepair extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String title;
  @HiveField(2)
  int mileage;
  @HiveField(3)
  String description;
  @HiveField(4)
  DateTime date;
  @HiveField(5)
  String vehicleNode;
  @HiveField(6)
  Map<String, String> imagesIdUrl;
  @HiveField(7)
  final String breakageObjectId;
  CompletedRepair({
    required this.objectId,
    required this.title,
    required this.mileage,
    required this.description,
    required this.date,
    required this.vehicleNode,
    required this.imagesIdUrl,
    this.breakageObjectId = '',
  });

  static CompletedRepair getCompletedRepair({
    required ParseObject completedRepairObject,
    required List<ParseObject> imagesList,
  }) {
    final objectId = completedRepairObject.objectId ?? 'Нет objectId';
    final title =
        completedRepairObject.get<String>('title') ?? 'Название не указано';
    final mileage = completedRepairObject.get<int>('mileage') ?? 0;
    final description = completedRepairObject.get<String>('description') ??
        'Описание не предоставлено';
    final date = completedRepairObject.get<DateTime>('date') ?? DateTime.now();
    final vehicleNode = completedRepairObject.get<String>('vehicleNode') ??
        'Узел автомобиля не указан';
    final breakageObjectId = completedRepairObject
            .get<ParseObject>('breakage')
            ?.get<String>('objectId') ??
        '';
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

    return CompletedRepair(
      objectId: objectId,
      title: title,
      mileage: mileage,
      description: description,
      date: date,
      vehicleNode: vehicleNode,
      imagesIdUrl: imagesIdUrl,
      breakageObjectId: breakageObjectId,
    );
  }

  void updateCompletedRepair(
    String? title,
    int? mileage,
    String? description,
    DateTime? date,
    String? vehicleNode,
    Map<String, String>? imagesIdUrl,
  ) {
    if (title != null) {
      this.title = title;
    }
    if (mileage != null) {
      this.mileage = mileage;
    }
    if (description != null) {
      this.description = description;
    }
    if (date != null) {
      this.date = date;
    }
    if (vehicleNode != null) {
      this.vehicleNode = vehicleNode;
    }
    if (imagesIdUrl != null && imagesIdUrl.isNotEmpty) {
      this.imagesIdUrl.addAll(imagesIdUrl);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompletedRepair &&
        other.objectId == objectId &&
        other.title == title &&
        other.mileage == mileage &&
        other.description == description &&
        other.date == date &&
        other.vehicleNode == vehicleNode &&
        mapEquals(other.imagesIdUrl, imagesIdUrl) &&
        other.breakageObjectId == breakageObjectId;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        mileage.hashCode ^
        description.hashCode ^
        date.hashCode ^
        vehicleNode.hashCode ^
        imagesIdUrl.hashCode ^
        breakageObjectId.hashCode;
  }
}
