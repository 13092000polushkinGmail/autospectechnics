import 'package:autospectechnics/domain/api_clients/breakage_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/data_providers/breakage_data_provider.dart';
import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class BreakageService {
  final String _vehicleObjectId;

  final _breakageApiClient = BreakageApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

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
        photosURL: savedImagesIdUrl.values.toList(),
      );
      await _breakageDataProvider.putBreakageToHive(breakage);
    }
  }

  Future<List<Breakage>> downloadVehicleBreakages() async {
    final vehicleBreakagesFromServer = await _breakageApiClient.getVehicleBreakageList(
        vehicleObjectId: _vehicleObjectId);
    await _breakageDataProvider
        .deleteUnnecessaryBreakagesFromHive(vehicleBreakagesFromServer);
    for (var breakage in vehicleBreakagesFromServer) {
      await _breakageDataProvider.putBreakageToHive(breakage);
    }
    return await getVehicleBreakagesFromHive();
  }

  Future<List<Breakage>> getVehicleBreakagesFromHive() async {
    final vehicleBreakages =
        await _breakageDataProvider.getBreakagesListFromHive();
    vehicleBreakages.sort((b, a) => a.dangerLevel.compareTo(b.dangerLevel));
    return vehicleBreakages;
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
