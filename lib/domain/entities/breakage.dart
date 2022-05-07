import 'package:parse_server_sdk/parse_server_sdk.dart';

class Breakage {
  final String objectId;
  final String title;
  final String vehicleNode;
  final int dangerLevel;
  final String description;
  final bool isFixed;
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
}
