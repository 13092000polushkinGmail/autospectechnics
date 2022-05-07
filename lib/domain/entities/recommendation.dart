import 'package:parse_server_sdk/parse_server_sdk.dart';

class Recommendation {
  final String objectId;
  final String title;
  final String vehicleNode;
  final String description;
  final bool isCompleted;
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
}
