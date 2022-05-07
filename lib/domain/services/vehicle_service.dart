import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/vehicle_api_client.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/entities/vehicle_details.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class VehicleService {
  final _vehicleApiClient = VehicleApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  Future<void> createVehicle({
    required String model,
    required int mileage,
    String? licensePlate,
    String? description,
    XFile? image,
  }) async {
    final vehicleObjectId = await _vehicleApiClient.saveVehicleToDatabase(
      model: model,
      mileage: mileage,
      licensePlate: licensePlate,
      description: description,
    );
    if (vehicleObjectId != null && image != null) {
      final savedImagesObjectIds =
          await _imagesApiClient.saveImagesToDatabase(<XFile>[image]);
      await _photosToEntityApiClient.addPhotoPointerToEntity(
          parseObjectName: ParseObjectNames.vehicle,
          entityObjectId: vehicleObjectId,
          imageObjectId: savedImagesObjectIds[0]);
    }
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final vehiclesList = await _vehicleApiClient.getVehiclesList();
    return vehiclesList;
  }

  Future<VehicleDetails?> getVehicleDetails({
    required String vehicleObjectId,
  }) async {
    final vehicleDetails = await _vehicleApiClient.getVehicleDetails(
        vehicleObjectId: vehicleObjectId);
    return vehicleDetails;
  }
}
