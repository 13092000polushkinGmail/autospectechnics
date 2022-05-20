import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'building_object.g.dart';

@HiveType(typeId: 4)
class BuildingObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime finishDate;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final bool isCompleted;
  @HiveField(6)
  final List<String> photosURL;
  BuildingObject({
    required this.objectId,
    required this.title,
    required this.startDate,
    required this.finishDate,
    required this.description,
    required this.isCompleted,
    required this.photosURL,
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

    List<String> photosURL = [];
    for (var imageParseObject in imagesList) {
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageURL != null) {
        photosURL.add(imageURL);
      }
    }

    return BuildingObject(
      objectId: objectId,
      title: title,
      startDate: startDate,
      finishDate: finishDate,
      description: description,
      isCompleted: isCompleted,
      photosURL: photosURL,
    );
  }
}
