import 'package:parse_server_sdk/parse_server_sdk.dart';

class VehicleDetails {
  final String objectId;
  final String model;
  final int mileage;
  final String? licensePlate;
  final String? description;
  final String? imageURL;
  VehicleDetails({
    required this.objectId,
    required this.model,
    required this.mileage,
    this.licensePlate,
    this.description,
    this.imageURL,
  });

  static VehicleDetails getVehicleDetails({
    required ParseObject vehicleObject,
  }) {
    final objectId = vehicleObject.objectId ?? 'Нет objectId';
    final model = vehicleObject.get<String>('model') ?? 'Марка и модель неизвестны';
    final mileage = vehicleObject.get<int>('mileage') ?? 0;
    final licensePlate =
        vehicleObject.get<String>('licensePlate') ?? 'Гос. номер не задан';
    final description =
        vehicleObject.get<String>('description') ?? 'Описание отсутствует';

    final imageParseObject = vehicleObject.get<ParseObject>('photo');
    String? imageURL;
    if (imageParseObject != null) {
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
    }

    return VehicleDetails(
      objectId: objectId,
      model: model,
      mileage: mileage,
      licensePlate: licensePlate,
      description: description,
      imageURL: imageURL,
    );
  }
}
