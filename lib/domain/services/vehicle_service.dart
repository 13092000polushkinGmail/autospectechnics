import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/vehicle_api_client.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_data_provider.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class VehicleService {
  final _vehicleApiClient = VehicleApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  final _vehicleDataProvider = VehicleDataProvider();

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
        imageObjectId: savedImagesObjectIds.keys.toList().first,
      );
    }
  }

  Future<List<Vehicle>> downloadAllVehicles() async {
    final vehiclesList = await _vehicleApiClient.getVehiclesList();
    for (Vehicle vehicle in vehiclesList) {
      await _vehicleDataProvider.putVehicleToHive(vehicle);
    }
    final list = await _vehicleDataProvider.getVehiclesListFromHive();
    return list;
  }

  Future<List<Vehicle>> getAllVehiclesFromHive() async {
    final vehiclesList = await _vehicleDataProvider.getVehiclesListFromHive();
    return vehiclesList;
  }

  Future<Vehicle?> getVehicleFromHive({
    required String vehicleObjectId,
  }) async {
    final vehicle =
        await _vehicleDataProvider.getVehicleFromHive(vehicleObjectId);
    return vehicle;
  }
}
