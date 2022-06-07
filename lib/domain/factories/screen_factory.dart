import 'package:autospectechnics/ui/screens/adding_breakage/adding_breakage_screen.dart';
import 'package:autospectechnics/ui/screens/adding_breakage/adding_breakage_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_completed_repair/adding_completed_repair_screen.dart';
import 'package:autospectechnics/ui/screens/adding_completed_repair/adding_completed_repair_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_screen.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_recommendation/adding_recommendation_screen.dart';
import 'package:autospectechnics/ui/screens/adding_recommendation/adding_recommendation_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_screen.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/screens/breakages/breakage_details/breakage_details_screen.dart';
import 'package:autospectechnics/ui/screens/breakages/breakage_details/breakage_details_view_model.dart';
import 'package:autospectechnics/ui/screens/breakages/breakages_screen.dart';
import 'package:autospectechnics/ui/screens/breakages/breakages_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_screen.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/screens/object_main_info/object_main_info_screen.dart';
import 'package:autospectechnics/ui/screens/object_main_info/object_main_info_view_model.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendation_details/recommendation_details_screen.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendation_details/recommendation_details_view_model.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendations_screen.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendations_view_model.dart';
import 'package:autospectechnics/ui/screens/repair_history/completed_repair/completed_repair_screen.dart';
import 'package:autospectechnics/ui/screens/repair_history/completed_repair/completed_repair_view_model.dart';
import 'package:autospectechnics/ui/screens/repair_history/repair_history_screen.dart';
import 'package:autospectechnics/ui/screens/repair_history/repair_history_view_model.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/routine_maintenance_screen.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/routine_maintenance_view_model.dart';
import 'package:autospectechnics/ui/screens/vehicle_information/vehicle_information_screen.dart';
import 'package:autospectechnics/ui/screens/vehicle_information/vehicle_information_view_model.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/vehicle_main_info_screen.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/vehicle_main_info_view_model.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/writing_engine_hours/writing_engine_hours_screen.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/writing_engine_hours/writing_engine_hours_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeMainTabs() {
    return ChangeNotifierProvider(
      create: (context) => MainTabsViewModel(context),
      child: const MainTabsScreen(),
    );
  }

  Widget makeAddingVehicle(String vehicleId, int pageNumber) {
    return ChangeNotifierProvider(
      create: (context) =>
          AddingVehicleViewModel(vehicleId, pageNumber, context),
      child: const AddingVehicleScreen(),
    );
  }

  Widget makeVehicleMainInfo(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) => VehicleMainInfoViewModel(vehicleObjectId, context),
      child: const VehicleMainInfoScreen(),
    );
  }

  Widget makeVehicleInformation(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) =>
          VehicleInformationViewModel(vehicleObjectId, context),
      child: const VehicleInformationScreen(),
    );
  }

  Widget makeRecommendations(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) => RecommendationsViewModel(vehicleObjectId, context),
      child: const RecommendationsScreen(),
    );
  }

  Widget makeRecommendationDetails(
      String vehicleObjectId, String recommendationObjectId) {
    return ChangeNotifierProvider(
      create: (context) => RecommendationDetailsViewModel(
          vehicleObjectId, recommendationObjectId, context),
      child: const RecommendationDetailsScreen(),
    );
  }

  Widget makeAddingRecommendation(
      String vehicleObjectId, String recommendationObjectId) {
    return ChangeNotifierProvider(
      create: (context) => AddingRecommendationViewModel(
        vehicleObjectId,
        recommendationObjectId,
        context,
      ),
      child: const AddingRecommendationScreen(),
    );
  }

  Widget makeBreakages(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) => BreakagesViewModel(vehicleObjectId, context),
      child: const BreakagesScreen(),
    );
  }

  Widget makeBreakageDetails(String vehicleObjectId, String breakageObjectId) {
    return ChangeNotifierProvider(
      create: (context) =>
          BreakageDetailsViewModel(vehicleObjectId, breakageObjectId, context),
      child: const BreakageDetailsScreen(),
    );
  }

  Widget makeAddingBreakage(String vehicleObjectId, String breakageObjectId) {
    return ChangeNotifierProvider(
      create: (context) => AddingBreakageViewModel(
        vehicleObjectId,
        breakageObjectId,
        context,
      ),
      child: const AddingBreakageScreen(),
    );
  }

  Widget makeRepairHistory(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) => RepairHistoryViewModel(vehicleObjectId, context),
      child: const RepairHistoryScreen(),
    );
  }

  Widget makeCompletedRepair(
      String vehicleObjectId, String completedRepairObjectId) {
    return ChangeNotifierProvider(
      create: (context) => CompletedRepairViewModel(
          vehicleObjectId, completedRepairObjectId, context),
      child: const CompletedRepairScreen(),
    );
  }

  Widget makeAddingCompletedRepair(
      String vehicleObjectId, String completedRepairObjectId) {
    return ChangeNotifierProvider(
      create: (context) => AddingCompletedRepairViewModel(
        vehicleObjectId,
        completedRepairObjectId,
        context,
      ),
      child: const AddingCompletedRepairScreen(),
    );
  }

  Widget makeRoutineMaintenance(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) =>
          RoutineMaintenanceViewModel(vehicleObjectId, context),
      child: const RoutineMaintenanceScreen(),
    );
  }

  Widget makeWritingEngineHours(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (context) =>
          WritingEngineHoursViewModel(vehicleObjectId, context),
      child: const WritingEngineHoursScreen(),
    );
  }

  Widget makeObjectMainInfo(String buildingObjectId) {
    return ChangeNotifierProvider(
      create: (context) => ObjectMainInfoViewModel(buildingObjectId, context),
      child: const ObjectMainInfoScreen(),
    );
  }

  Widget makeAddingObject(String buildingObjectId) {
    return ChangeNotifierProvider(
      create: (context) => AddingObjectViewModel(buildingObjectId, context),
      child: const AddingObjectScreen(),
    );
  }
}
