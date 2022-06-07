import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:hive/hive.dart';

class CompletedRepairDataProvider {
  late Future<Box<CompletedRepair>> _futureBox;
  final String _vehicleId;
  CompletedRepairDataProvider(this._vehicleId) {
    _futureBox = BoxManager.instance.openBox(
      name: 'completed_repair_box_$_vehicleId',
      typeId: 7,
      adapter: CompletedRepairAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getCompletedRepairStream() async {
    final box = await _futureBox;
    final completedRepairStream = box.watch();
    return completedRepairStream;
  }

  Future<void> putCompletedRepairToHive(CompletedRepair completedRepair) async {
    final box = await _futureBox;
    final completedRepairFromHive = box.get(completedRepair.objectId);
    if (completedRepairFromHive == null ||
        completedRepairFromHive != completedRepair) {
      await box.put(completedRepair.objectId, completedRepair);
    }
  }

  Future<void> updateCompletedRepairInHive({
    required String completedRepairId,
    String? title,
    int? mileage,
    String? description,
    DateTime? date,
    String? vehicleNode,
    Map<String, String>? imagesIdUrl,
  }) async {
    final box = await _futureBox;
    final completedRepair = box.get(completedRepairId);
    if (completedRepair != null) {
      completedRepair.updateCompletedRepair(
        title,
        mileage,
        description,
        date,
        vehicleNode,
        imagesIdUrl,
      );
      await completedRepair.save();
    }
  }

  Future<void> deleteCompletedRepairFromHive(String completedRepairId) async {
    final box = await _futureBox;
    await box.delete(completedRepairId);
  }

  Future<List<CompletedRepair>> getCompletedRepairsListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<CompletedRepair?> getCompletedRepairFromHive(
      String completedRepairId) async {
    final box = await _futureBox;
    final completedRepair = box.get(completedRepairId);
    return completedRepair;
  }

  Future<void> deleteUnnecessaryCompletedRepairsFromHive(
      List<CompletedRepair> vehicleCompletedRepairsFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var completedRepair in vehicleCompletedRepairsFromServer) {
      if (keysToDelete.contains(completedRepair.objectId)) {
        keysToDelete.remove(completedRepair.objectId);
      }
    }
    box.deleteAll(keysToDelete);
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
