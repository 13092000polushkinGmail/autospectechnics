import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:hive/hive.dart';

class BreakageDataProvider {
  late Future<Box<Breakage>> _futureBox;
  final String _vehicleId;
  BreakageDataProvider(this._vehicleId) {
    _futureBox = BoxManager.instance.openBox(
      name: 'breakage_box_$_vehicleId',
      typeId: 1,
      adapter: BreakageAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getBreakageStream() async {
    final box = await _futureBox;
    final breakageStream = box.watch();
    return breakageStream;
  }

  Future<void> putBreakageToHive(Breakage breakage) async {
    final box = await _futureBox;
    final breakageFromHive = box.get(breakage.objectId);
    if (breakageFromHive == null || breakageFromHive != breakage) {
      await box.put(breakage.objectId, breakage);
    }
  }

  Future<List<Breakage>> getBreakagesListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<Breakage?> getBreakageFromHive(String breakageId) async {
    final box = await _futureBox;
    final breakage = box.get(breakageId);
    return breakage;
  }

  Future<void> deleteUnnecessaryBreakagesFromHive(
      List<Breakage> vehicleBreakagesFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var breakage in vehicleBreakagesFromServer) {
      if (keysToDelete.contains(breakage.objectId)) {
        keysToDelete.remove(breakage.objectId);
      }
    }
    box.deleteAll(keysToDelete);
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
