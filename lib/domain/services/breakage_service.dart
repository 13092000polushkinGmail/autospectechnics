import 'package:autospectechnics/domain/api_clients/breakage_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class BreakageService {
  final _breakageApiClient = BreakageApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  Future<void> createBreakage({
    required String title,
    required String vehicleNode,
    required int dangerLevel,
    required String description,
    bool isFixed = false,
    List<XFile>? imagesList,
    required String vehicleObjectId,
  }) async {
    final breakageObjectId = await _breakageApiClient.saveBreakageToDatabase(
      title: title,
      vehicleNode: vehicleNode,
      dangerLevel: dangerLevel,
      description: description,
      isFixed: isFixed,
      vehicleObjectId: vehicleObjectId,
    );

    if (breakageObjectId != null &&
        imagesList != null &&
        imagesList.isNotEmpty) {
      final savedImagesObjectIds =
          await _imagesApiClient.saveImagesToDatabase(imagesList);
      await _photosToEntityApiClient.addPhotosRelationToEntity(
        parseObjectName: ParseObjectNames.breakage,
        entityObjectId: breakageObjectId,
        imageObjectIdList: savedImagesObjectIds,
      );
    }
  }

  Future<List<Breakage>> getVehicleBreakages({
    required String vehicleObjectId,
  }) async {
    final vehicleBreakages = await _breakageApiClient.getVehicleBreakageList(
        vehicleObjectId: vehicleObjectId);
    return vehicleBreakages;
  }

  Future<Breakage?> getBreakage(
    String breakageObjectId,
  ) async {
    final breakage =
        await _breakageApiClient.getBreakage(objectId: breakageObjectId);
    return breakage;
  }
}
