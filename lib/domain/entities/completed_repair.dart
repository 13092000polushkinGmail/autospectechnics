import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'completed_repair.g.dart';

@HiveType(typeId: 7)
class CompletedRepair {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int mileage;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String vehicleNode;
  @HiveField(6)
  final List<String> photosURL;
  @HiveField(7)
  final String breakageObjectId;
  CompletedRepair({
    required this.objectId,
    required this.title,
    required this.mileage,
    required this.description,
    required this.date,
    required this.vehicleNode,
    required this.photosURL,
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
    List<String> photosURL = [];
    for (var imageParseObject in imagesList) {
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageURL != null) {
        photosURL.add(imageURL);
      }
    }

    return CompletedRepair(
      objectId: objectId,
      title: title,
      mileage: mileage,
      description: description,
      date: date,
      vehicleNode: vehicleNode,
      photosURL: photosURL,
      breakageObjectId: breakageObjectId,
    );
  }
}
