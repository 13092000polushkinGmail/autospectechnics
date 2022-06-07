import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 6)
class Recommendation extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String vehicleNode;
  @HiveField(3)
  String description;
  @HiveField(4)
  bool isCompleted;
  @HiveField(5)
  Map<String, String> imagesIdUrl;
  Recommendation({
    required this.objectId,
    required this.title,
    required this.vehicleNode,
    required this.description,
    required this.isCompleted,
    required this.imagesIdUrl,
  });

  static Recommendation getRecommendation({
    required ParseObject recommendationObject,
    required List<ParseObject> imagesList,
  }) {
    final objectId = recommendationObject.objectId ?? 'Нет objectId';
    final title =
        recommendationObject.get<String>('title') ?? 'Название не указано';
    final vehicleNode = recommendationObject.get<String>('vehicleNode') ??
        'Узел автомобиля не указан';
    final description = recommendationObject.get<String>('description') ??
        'Описание не предоставлено';
    final isCompleted = recommendationObject.get<bool>('isCompleted') ?? false;
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

    return Recommendation(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      description: description,
      isCompleted: isCompleted,
      imagesIdUrl: imagesIdUrl,
    );
  }

  void updateRecommendation(
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
    Map<String, String>? imagesIdUrl,
  ) {
    if (title != null) {
      this.title = title;
    }
    if (vehicleNode != null) {
      this.vehicleNode = vehicleNode;
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

    return other is Recommendation &&
        other.objectId == objectId &&
        other.title == title &&
        other.vehicleNode == vehicleNode &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        mapEquals(other.imagesIdUrl, imagesIdUrl);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        vehicleNode.hashCode ^
        description.hashCode ^
        isCompleted.hashCode ^
        imagesIdUrl.hashCode;
  }
}
