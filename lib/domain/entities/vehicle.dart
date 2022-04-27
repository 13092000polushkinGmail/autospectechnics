import 'package:autospectechnics/domain/entities/image_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class Vehicle {
  final String objectId;
  final String model;
  final int mileage;
  final String? licensePlate;
  final String? description;
  final ImageParse? image;
  Vehicle({
    required this.objectId,
    required this.model,
    required this.mileage,
    this.licensePlate,
    this.description,
    this.image,
  });

  static Vehicle getVehiclefromParseObject(ParseObject vehicleParseObject) {
    final objectId = vehicleParseObject.objectId!;
    final model = vehicleParseObject.get<String>('model')!;
    final mileage = vehicleParseObject.get<int>('mileage')!;
    final licensePlate = vehicleParseObject.get<String>('licensePlate');
    final description = vehicleParseObject.get<String>('description');
    final imageParseObject = vehicleParseObject.get<ParseObject>('photo');
    ImageParse? image;
    if (imageParseObject != null) {
      image = ImageParse.getImageFromImageParseObject(imageParseObject);
    }
    return Vehicle(
      objectId: objectId,
      model: model,
      mileage: mileage,
      licensePlate: licensePlate,
      description: description,
      image: image,
    );
  }
}
