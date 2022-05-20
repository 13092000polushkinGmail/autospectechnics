import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:hive/hive.dart';

class VehicleDataProvider {
  Future<Box<Vehicle>> _openBox() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(RoutineMaintenanceHoursInfoAdapter());
    }
    return await BoxManager.instance.openBox(
      name: 'vehicles_box',
      typeId: 2,
      adapter: VehicleAdapter(),
    );
  }

  Future<void> putVehicleToHive(Vehicle vehicle) async {
    final box = await _openBox();
    //TODO Если объект существует, нужно сверять с добавляемым, если отличаются менять на новый, если такой же ничего не делать. Это на случай, если подписываться на изменения в box, чтобы лишний раз не обновлять виджет
    // if (box.containsKey(breakage.objectId)) return;
    await box.put(vehicle.objectId, vehicle);
    await BoxManager.instance.closeBox(box);
  }

  Future<List<Vehicle>> getVehiclesListFromHive() async {
    final box = await _openBox();
    final list = box.values.toList();
    await BoxManager.instance.closeBox(box);
    return list;
  }

  Future<Vehicle?> getVehicleFromHive(String vehicleId) async {
    final box = await _openBox();
    final vehicle = box.get(vehicleId);
    await BoxManager.instance.closeBox(box);
    return vehicle;
  }

  Future<void> deleteAllVehiclesFromHive() async {
    final box = await _openBox();
    await box.clear();
    await BoxManager.instance.closeBox(box);
  }

  // Future<void> closeDataProvider() async {
  //   await BoxManager.instance.closeBox(await futureBox);
  // }
}
