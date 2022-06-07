import 'package:autospectechnics/domain/api_clients/completed_repair_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/data_providers/completed_repair_data_provider.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class CompletedRepairService {
  final _completedRepairApiClient = CompletedRepairApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  final String _vehicleObjectId;
  CompletedRepairService(this._vehicleObjectId);
  late final _completedRepairDataProvider =
      CompletedRepairDataProvider(_vehicleObjectId);

  Future<void> createCompletedRepair({
    required String title,
    required int mileage,
    required String description,
    required DateTime date,
    required String vehicleNode,
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
      vehicleObjectId: _vehicleObjectId,
      breakageObjectId: breakageObjectId,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (completedRepairObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.completedRepair,
          entityObjectId: completedRepairObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      final completedRepair = CompletedRepair(
        objectId: completedRepairObjectId,
        title: title,
        mileage: mileage,
        description: description,
        date: date,
        vehicleNode: vehicleNode,
        imagesIdUrl: savedImagesIdUrl,
        breakageObjectId: breakageObjectId ?? '',
      );
      await _completedRepairDataProvider
          .putCompletedRepairToHive(completedRepair);
    }
  }

  Future<List<CompletedRepair>> downloadVehicleCompletedRepairs() async {
    final vehicleCompletedRepairsFromServer = await _completedRepairApiClient
        .getCompletedRepairList(vehicleObjectId: _vehicleObjectId);
    await _completedRepairDataProvider
        .deleteUnnecessaryCompletedRepairsFromHive(
            vehicleCompletedRepairsFromServer);
    for (var completedRepair in vehicleCompletedRepairsFromServer) {
      await _completedRepairDataProvider
          .putCompletedRepairToHive(completedRepair);
    }
    return await getVehicleCompletedRepairsFromHive();
  }

  Future<List<CompletedRepair>> getVehicleCompletedRepairsFromHive() async {
    final vehicleCompletedRepairs =
        await _completedRepairDataProvider.getCompletedRepairsListFromHive();
    vehicleCompletedRepairs.sort((b, a) => a.date.compareTo(b.date));
    return vehicleCompletedRepairs;
  }

  Future<CompletedRepair?> geCompletedRepairFromHive(
      String completedRepairObjectId) async {
    final completedRepair = _completedRepairDataProvider
        .getCompletedRepairFromHive(completedRepairObjectId);
    return completedRepair;
  }

  Future<Stream<BoxEvent>> getCompletedRepairStream() async {
    final completedRepairStream =
        _completedRepairDataProvider.getCompletedRepairStream();
    return completedRepairStream;
  }

  Future<void> updateCompletedRepair({
    required String objectId,
    String? title,
    int? mileage,
    String? description,
    DateTime? date,
    String? vehicleNode,
    List<XFile>? imagesList,
  }) async {
    final completedRepairObjectId =
        await _completedRepairApiClient.updateCompletedRepair(
      objectId: objectId,
      title: title,
      mileage: mileage,
      description: description,
      date: date,
      vehicleNode: vehicleNode,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (completedRepairObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.completedRepair,
          entityObjectId: completedRepairObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      await _completedRepairDataProvider.updateCompletedRepairInHive(
        completedRepairId: completedRepairObjectId,
        title: title,
        mileage: mileage,
        description: description,
        date: date,
        vehicleNode: vehicleNode,
        imagesIdUrl: savedImagesIdUrl,
      );
    }
  }

  Future<void> deleteCompletedRepair(String completedRepairId) async {
    await _completedRepairApiClient
        .deleteCompletedRepairFromDatabase(completedRepairId);
    await _completedRepairDataProvider
        .deleteCompletedRepairFromHive(completedRepairId);
  }

  Future<void> dispose() async {
    await _completedRepairDataProvider.dispose();
  }
}
