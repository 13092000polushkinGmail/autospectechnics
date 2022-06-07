import 'package:hive/hive.dart';

import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';

class VehicleDataProvider {
  late Future<Box<Vehicle>> _futureBox;
  VehicleDataProvider() {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(RoutineMaintenanceHoursInfoAdapter());
    }
    _futureBox = BoxManager.instance.openBox(
      name: 'vehicles_box',
      typeId: 2,
      adapter: VehicleAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getVehicleStream() async {
    final box = await _futureBox;
    final vehicleStream = box.watch();
    return vehicleStream;
  }

  Future<void> putVehicleToHive(Vehicle vehicle) async {
    final box = await _futureBox;
    final vehicleFromHive = box.get(vehicle.objectId);
    if (vehicleFromHive == null || vehicleFromHive != vehicle) {
      await box.put(vehicle.objectId, vehicle);
    }
  }

  Future<void> updateVehicleInHive({
    required String vehicleId,
    String? model,
    int? mileage,
    int? vehicleType,
    String? licensePlate,
    String? description,
    int? breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
    Map<String, String>? imageIdUrl,
    bool doResetRoutineMaintenanceInfo = false,
  }) async {
    final box = await _futureBox;
    final vehicle = box.get(vehicleId);
    if (vehicle != null) {
      final oldVehicle = vehicle.copyWith();
      vehicle.updateVehicle(
        model: model,
        mileage: mileage,
        vehicleType: vehicleType,
        licensePlate: licensePlate,
        description: description,
        breakageDangerLevel: breakageDangerLevel,
        hoursInfo: hoursInfo,
        imageIdUrl: imageIdUrl,
        doResetRoutineMaintenanceInfo: doResetRoutineMaintenanceInfo,
      );
      if (vehicle != oldVehicle) {
        await vehicle.save();
      }
    }
  }

  Future<void> deleteVehicleFromHive(String vehicleId) async {
    final box = await _futureBox;
    await box.delete(vehicleId);
    final lowerVehicleId = vehicleId.toString().toLowerCase();
    Hive.deleteBoxFromDisk('recommendation_box_$lowerVehicleId');
    Hive.deleteBoxFromDisk('routine_maintenance_box_$lowerVehicleId');
    Hive.deleteBoxFromDisk('breakage_box_$lowerVehicleId');
    Hive.deleteBoxFromDisk('completed_repair_box_$lowerVehicleId');
  }

  Future<List<Vehicle>> getVehiclesListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<Vehicle?> getVehicleFromHive(String vehicleId) async {
    final box = await _futureBox;
    final vehicle = box.get(vehicleId);
    return vehicle;
  }

  Future<void> deleteAllUnnecessaryVehiclesFromHive(
      List<Vehicle> vehiclesFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var vehicle in vehiclesFromServer) {
      if (keysToDelete.contains(vehicle.objectId)) {
        keysToDelete.remove(vehicle.objectId);
      }
    }
    for (var key in keysToDelete) {
      box.delete(key);
      final vehicleId = key.toString().toLowerCase();
      Hive.deleteBoxFromDisk('recommendation_box_$vehicleId');
      Hive.deleteBoxFromDisk('routine_maintenance_box_$vehicleId');
      Hive.deleteBoxFromDisk('breakage_box_$vehicleId');
      Hive.deleteBoxFromDisk('completed_repair_box_$vehicleId');
      //TODO Наверное еще удалить записи из таблицы Vehicle-BuildingObject
    }
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
