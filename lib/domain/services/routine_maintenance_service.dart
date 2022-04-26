import 'dart:io';

import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RoutineMaintenanceService {
  //TODO: сделать обработку ошибок, убрать принты и как-то сообщать пользователю об ошибке или успехе

  Future<void> saveRoutineMaintenance({
    required String title,
    required int periodicity,
    required int engineHoursValue,
    required String vehicleNode,
  }) async {
    var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
    routineMaintenance.set(RoutineMaintenanceFieldNames.title, title);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.periodicity, periodicity);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.engineHoursValue, engineHoursValue);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.vehicleNode, vehicleNode);

    final ParseResponse apiResponse = await routineMaintenance.save();

    if (apiResponse.success && apiResponse.results != null) {
      print('Топчик');
    } else if (apiResponse.error?.exception is SocketException) {
      print('Проверьте подключение к интернету');
    } else {
      print('Нет заказов');
    }
  }

  Future<RoutineMaintenance> getRoutineMaintenance({
    String? objectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(ParseObjectNames.routineMaintenance));

    if (objectId != null) {
      parseQuery.whereEqualTo(
        RoutineMaintenanceFieldNames.objectId,
        objectId,
      );
    }

    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      final parseRoutineMaintenance = apiResponse.results!.first as ParseObject;

      final objectId = parseRoutineMaintenance.objectId ?? 'Нет objectId';
      final title = parseRoutineMaintenance
              .get<String>(RoutineMaintenanceFieldNames.title) ??
          'Название не указано';
      final periodicity = parseRoutineMaintenance
              .get<int>(RoutineMaintenanceFieldNames.periodicity) ??
          0;
      final engineHoursValue = parseRoutineMaintenance
              .get<int>(RoutineMaintenanceFieldNames.engineHoursValue) ??
          0;
      final vehicleNode = parseRoutineMaintenance
              .get<String>(RoutineMaintenanceFieldNames.vehicleNode) ??
          'Узел автомобиля не указан';

      final routineMaintenance = RoutineMaintenance(
          objectId: objectId,
          title: title,
          periodicity: periodicity,
          engineHoursValue: engineHoursValue,
          vehicleNode: vehicleNode);

      return routineMaintenance;
      //TODO Костыли с ошшибками, чтобы заработал метод
    } else if (apiResponse.error?.exception is SocketException) {
      print('Проверьте подключение к интернету');
      throw Exception();
    } else {
      print('Нет заказов');
      throw Exception();
    }
  }

  Future<List<RoutineMaintenance>> getRoutineMaintenanceList() async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(ParseObjectNames.routineMaintenance));

    final ParseResponse apiResponse = await parseQuery.query();

    final List<RoutineMaintenance> routineMaintenanceList = [];

    if (apiResponse.success && apiResponse.results != null) {
      for (var element in apiResponse.results!) {
        element = element as ParseObject;

        final objectId = element.objectId ?? 'Нет objectId';
        final title = element.get<String>(RoutineMaintenanceFieldNames.title) ??
            'Название не указано';
        final periodicity =
            element.get<int>(RoutineMaintenanceFieldNames.periodicity) ?? 0;
        final engineHoursValue =
            element.get<int>(RoutineMaintenanceFieldNames.engineHoursValue) ??
                0;
        final vehicleNode =
            element.get<String>(RoutineMaintenanceFieldNames.vehicleNode) ??
                'Узел автомобиля не указан';

        final routineMaintenance = RoutineMaintenance(
            objectId: objectId,
            title: title,
            periodicity: periodicity,
            engineHoursValue: engineHoursValue,
            vehicleNode: vehicleNode);
        routineMaintenanceList.add(routineMaintenance);
      }
    } else if (apiResponse.error?.exception is SocketException) {
      print('Проверьте подключение к интернету');
    } else {
      print('Нет заказов');
    }

    return routineMaintenanceList;
  }

  Future<void> updateRoutineMaintenance({
    required String objectId,
    String? title,
    int? periodicity,
    int? engineHoursValue,
    String? vehicleNode,
  }) async {
    var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
    routineMaintenance.objectId = objectId;

    if (title != null) {
      routineMaintenance.set(RoutineMaintenanceFieldNames.title, title);
    }

    if (periodicity != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.periodicity, periodicity);
    }

    if (engineHoursValue != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.engineHoursValue, engineHoursValue);
    }

    if (vehicleNode != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.vehicleNode, vehicleNode);
    }

    final ParseResponse apiResponse = await routineMaintenance.save();

    if (apiResponse.success && apiResponse.results != null) {
      print('Топчик');
    } else if (apiResponse.error?.exception is SocketException) {
      print('Проверьте подключение к интернету');
    } else {
      print('Нет заказов');
    }
  }
}

abstract class RoutineMaintenanceFieldNames {
  static const objectId = 'objectId';
  static const title = 'title';
  static const periodicity = 'periodicity';
  static const engineHoursValue = 'engineHoursValue';
  static const vehicleNode = 'vehicleNode';
}
