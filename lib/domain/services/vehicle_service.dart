import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/vehicle_api_client.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_data_provider.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class VehicleService {
  final _vehicleApiClient = VehicleApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  final _vehicleDataProvider = VehicleDataProvider();

  Future<String?> createVehicle({
    required String model,
    required int mileage,
    required int vehicleType,
    String? licensePlate,
    String? description,
    XFile? image,
  }) async {
    final vehicleObjectId = await _vehicleApiClient.saveVehicleToDatabase(
      model: model,
      mileage: mileage,
      vehicleType: vehicleType,
      licensePlate: licensePlate,
      description: description,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (vehicleObjectId != null) {
      if (image != null) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(<XFile>[image]);
        await _photosToEntityApiClient.addPhotoPointerToEntity(
          parseObjectName: ParseObjectNames.vehicle,
          entityObjectId: vehicleObjectId,
          imageObjectId: savedImagesIdUrl.keys.toList().first,
        );
      }
      final vehicle = Vehicle(
        objectId: vehicleObjectId,
        model: model,
        mileage: mileage,
        vehicleType: vehicleType,
        breakageDangerLevel: -1,
        hoursInfo: null,
        description: description,
        licensePlate: licensePlate,
        imageIdUrl: savedImagesIdUrl,
      );
      await _vehicleDataProvider.putVehicleToHive(vehicle);
      return vehicleObjectId;
    }
  }

  //Этот метод отличается от остальных подобных в других сервисах. Он не сразу добавляет данные о ТС в Hive.
  //Перед этим в mainTabsViewModel происходит загрузка данных о регламентных работах. Далее вызывается метод VehicleService, putVehiclesToHive. Пояснение:
  //Загружаем технику с сервера, но не синхронизируем с Hive на данном этапе, потому что
  //с сервера приходит техника без инофрмации о регламентных работах, она равна null
  //из-за этого каждый раз при загрузке с интернета на главном экране, разделе автопарк, полоски с прогрессбарами
  //заменяются на надпись "Регламенты не заданы", а после загрузки восстанавливаются
  Future<List<Vehicle>> downloadAllVehicles() async {
    final vehiclesListFromServer = await _vehicleApiClient.getVehiclesList();
    await _vehicleDataProvider
        .deleteAllUnnecessaryVehiclesFromHive(vehiclesListFromServer);
    return vehiclesListFromServer;
  }

  Future<void> putVehicleToHive(Vehicle vehicle) async {
    await _vehicleDataProvider.putVehicleToHive(vehicle);
  }

  Future<List<Vehicle>> getAllVehiclesFromHive() async {
    final vehiclesList = await _vehicleDataProvider.getVehiclesListFromHive();
    vehiclesList
        .sort((a, b) => a.model.toLowerCase().compareTo(b.model.toLowerCase()));
    return vehiclesList;
  }

  Future<Vehicle?> getVehicleFromHive({
    required String vehicleObjectId,
  }) async {
    final vehicle =
        await _vehicleDataProvider.getVehicleFromHive(vehicleObjectId);
    return vehicle;
  }

  Future<Stream<BoxEvent>> getVehicleStream() async {
    final vehicleStream = await _vehicleDataProvider.getVehicleStream();
    return vehicleStream;
  }

  Future<void> updateVehicle({
    required String vehicleId,
    String? model,
    int? mileage,
    int? vehicleType,
    String? licensePlate,
    String? description,
    int? breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
    XFile? image,
  }) async {
    final vehicleObjectId = await _vehicleApiClient.updateVehicle(
      objectId: vehicleId,
      model: model,
      mileage: mileage,
      vehicleType: vehicleType,
      licensePlate: licensePlate,
      description: description,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (vehicleObjectId != null) {
      if (image != null) {
        savedImagesIdUrl = await _imagesApiClient.saveImagesToDatabase([image]);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.vehicle,
          entityObjectId: vehicleObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      await _vehicleDataProvider.updateVehicleInHive(
          vehicleId: vehicleId,
          model: model,
          mileage: mileage,
          vehicleType: vehicleType,
          licensePlate: licensePlate,
          description: description,
          breakageDangerLevel: breakageDangerLevel,
          hoursInfo: hoursInfo,
          imageIdUrl: savedImagesIdUrl);
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _vehicleApiClient.deleteVehicleFromDatabase(vehicleId);
    await _vehicleDataProvider.deleteVehicleFromHive(vehicleId);
  }

  Future<void> dispose() async {
    await _vehicleDataProvider.dispose();
  }
}
