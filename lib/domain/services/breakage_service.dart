import 'package:autospectechnics/domain/api_clients/breakage_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/data_providers/breakage_data_provider.dart';
import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class BreakageService {
  final _breakageApiClient = BreakageApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  final String _vehicleObjectId;
  BreakageService(this._vehicleObjectId);
  late final _breakageDataProvider = BreakageDataProvider(_vehicleObjectId);

  Future<void> createBreakage({
    required String title,
    required String vehicleNode,
    required int dangerLevel,
    required String description,
    bool isFixed = false,
    List<XFile>? imagesList,
  }) async {
    final breakageObjectId = await _breakageApiClient.saveBreakageToDatabase(
      title: title,
      vehicleNode: vehicleNode,
      dangerLevel: dangerLevel,
      description: description,
      isFixed: isFixed,
      vehicleObjectId: _vehicleObjectId,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (breakageObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.breakage,
          entityObjectId: breakageObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      final breakage = Breakage(
        objectId: breakageObjectId,
        title: title,
        vehicleNode: vehicleNode,
        dangerLevel: dangerLevel,
        description: description,
        isFixed: isFixed,
        imagesIdUrl: savedImagesIdUrl,
      );
      await _breakageDataProvider.putBreakageToHive(breakage);
    }
  }

  Future<void> fixBreakage(String breakageId) async {
    final breakageObjectId = await _breakageApiClient.updateBreakage(
      objectId: breakageId,
      isFixed: true,
    );
    if (breakageObjectId != null) {
      await _breakageDataProvider.updateBreakageInHive(
          breakageId: breakageObjectId, isFixed: true);
    }
  }

  Future<void> updateBreakage({
    required String objectId,
    String? title,
    String? vehicleNode,
    int? dangerLevel,
    String? description,
    bool? isFixed,
    List<XFile>? imagesList,
  }) async {
    final breakageObjectId = await _breakageApiClient.updateBreakage(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      dangerLevel: dangerLevel,
      description: description,
      isFixed: isFixed,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (breakageObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.breakage,
          entityObjectId: breakageObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      await _breakageDataProvider.updateBreakageInHive(
        breakageId: breakageObjectId,
        title: title,
        vehicleNode: vehicleNode,
        dangerLevel: dangerLevel,
        description: description,
        isFixed: isFixed,
        imagesIdUrl: savedImagesIdUrl,
      );
    }
  }

  Future<void> deleteBreakage(String breakageId) async {
    await _breakageApiClient.deleteBreakage(breakageId);
    await _breakageDataProvider.deleteBreakageFromHive(breakageId);
  }

  Future<List<Breakage>> downloadAllVehicleBreakagesAndShowActive() async {
    final vehicleBreakagesFromServer = await _breakageApiClient
        .getVehicleBreakageList(vehicleObjectId: _vehicleObjectId);
    await _breakageDataProvider
        .deleteUnnecessaryBreakagesFromHive(vehicleBreakagesFromServer);
    for (var breakage in vehicleBreakagesFromServer) {
      await _breakageDataProvider.putBreakageToHive(breakage);
    }
    return await getActiveVehicleBreakagesFromHive();
  }

  Future<List<Breakage>> getActiveVehicleBreakagesFromHive() async {
    final vehicleBreakages =
        await _breakageDataProvider.getActiveBreakagesListFromHive();
    vehicleBreakages.sort((b, a) => a.dangerLevel.compareTo(b.dangerLevel));
    return vehicleBreakages;
  }

  Future<int> getVehicleDangerLevel() async {
    final activeBreakages = await getActiveVehicleBreakagesFromHive();
    activeBreakages.sort((b, a) => a.dangerLevel.compareTo(b.dangerLevel));
    if (activeBreakages.isNotEmpty) {
      return activeBreakages[0].dangerLevel;
    }
    return -1;
  }

  Future<Breakage?> getBreakageFromHive(String breakageObjectId) async {
    final breakage =
        await _breakageDataProvider.getBreakageFromHive(breakageObjectId);
    return breakage;
  }

  Future<Stream<BoxEvent>> getBreakageStream() async {
    final breakageStream = await _breakageDataProvider.getBreakageStream();
    return breakageStream;
  }

  Future<void> dispose() async {
    await _breakageDataProvider.dispose();
  }
}
