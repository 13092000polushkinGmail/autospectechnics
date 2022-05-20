import 'package:autospectechnics/domain/api_clients/completed_repair_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/data_providers/completed_repair_data_provider.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class CompletedRepairService {
  final _completedRepairDataProvider = CompletedRepairDataProvider();
  final _completedRepairApiClient = CompletedRepairApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  Future<void> createCompletedRepair({
    required String title,
    required int mileage,
    required String description,
    required DateTime date,
    required String vehicleNode,
    required String vehicleObjectId,
    String? breakageObjectId,
    List<XFile>? imagesList,
  }) async {
    final completedRepairObjectId =
        await _completedRepairApiClient.saveCompletedRepairToDatabase(
      title: title,
      mileage: mileage,
      description: description,
      date: date,
      vehicleNode: vehicleNode,
      vehicleObjectId: vehicleObjectId,
      breakageObjectId: breakageObjectId,
    );
    if (completedRepairObjectId != null &&
        imagesList != null &&
        imagesList.isNotEmpty) {
      final savedImagesObjectIds =
          await _imagesApiClient.saveImagesToDatabase(imagesList);
      await _photosToEntityApiClient.addPhotosRelationToEntity(
        parseObjectName: ParseObjectNames.completedRepair,
        entityObjectId: completedRepairObjectId,
        imageObjectIdList: savedImagesObjectIds.keys.toList(),
      );
    }
  }

  Future<List<CompletedRepair>> downloadVehicleCompletedRepairs({
    required String vehicleObjectId,
  }) async {
    final vehicleCompletedRepairs = await _completedRepairApiClient
        .getCompletedRepairList(vehicleObjectId: vehicleObjectId);
    await _completedRepairDataProvider
        .deleteAllCompletedRepairsFromHive(vehicleObjectId);
    for (var completedRepair in vehicleCompletedRepairs) {
      await _completedRepairDataProvider.putCompletedRepairToHive(
          completedRepair, vehicleObjectId);
    }
    return await getVehicleCompletedRepairsFromHive(
        vehicleObjectId: vehicleObjectId);
  }

  Future<List<CompletedRepair>> getVehicleCompletedRepairsFromHive({
    required String vehicleObjectId,
  }) async {
    final vehicleCompletedRepairs = await _completedRepairDataProvider
        .getCompletedRepairsListFromHive(vehicleObjectId);
    //TODO Нужна ли сортировка, не знаю, надо проверить как отображаются
    // vehicleBreakages.sort((b, a) => a.dangerLevel.compareTo(b.dangerLevel));
    return vehicleCompletedRepairs;
  }

  Future<CompletedRepair?> geCompletedRepairFromHive(
      String completedRepairObjectId, String vehicleId) async {
    final completedRepair = _completedRepairDataProvider
        .getCompletedRepairFromHive(completedRepairObjectId, vehicleId);
    return completedRepair;
  }
}
