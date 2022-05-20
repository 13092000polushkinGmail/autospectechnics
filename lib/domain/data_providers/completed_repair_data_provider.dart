import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:hive/hive.dart';

class CompletedRepairDataProvider {

  Future<Box<CompletedRepair>> _openBox(String vehicleId) async {
    return await BoxManager.instance.openBox(
      name: 'completed_repair_box_$vehicleId',
      typeId: 7,
      adapter: CompletedRepairAdapter(),
    );
  }

  Future<void> putCompletedRepairToHive(CompletedRepair completedRepair, String vehicleId) async {
    final box = await _openBox(vehicleId);
    await box.put(completedRepair.objectId, completedRepair);
    await BoxManager.instance.closeBox(box);
  }

  Future<List<CompletedRepair>> getCompletedRepairsListFromHive(String vehicleId) async {
    final box = await _openBox(vehicleId);
    final list = box.values.toList();
    await BoxManager.instance.closeBox(box);
    return list;
  }

  Future<CompletedRepair?> getCompletedRepairFromHive(
      String completedRepairId, String vehicleId) async {
    final box = await _openBox(vehicleId);
    final completedRepair = box.get(completedRepairId);
    await BoxManager.instance.closeBox(box);
    return completedRepair;
  }

  Future<void> deleteAllCompletedRepairsFromHive(String vehicleId) async {
    final box = await _openBox(vehicleId);
    await box.clear();
    await BoxManager.instance.closeBox(box);
  }
}