import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 6)
class Recommendation {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String vehicleNode;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final bool isCompleted;
  @HiveField(5)
  final List<String> photosURL;
  Recommendation({
    required this.objectId,
    required this.title,
    required this.vehicleNode,
    required this.description,
    required this.isCompleted,
    required this.photosURL,
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
    List<String> photosURL = [];
    for (var imageParseObject in imagesList) {
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageURL != null) {
        photosURL.add(imageURL);
      }
    }

    return Recommendation(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      description: description,
      isCompleted: isCompleted,
      photosURL: photosURL,
    );
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
        listEquals(other.photosURL, photosURL);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        vehicleNode.hashCode ^
        description.hashCode ^
        isCompleted.hashCode ^
        photosURL.hashCode;
  }
}
