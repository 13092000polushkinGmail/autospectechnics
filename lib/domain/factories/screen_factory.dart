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
import 'package:autospectechnics/ui/screens/routine_maintenance/writing_engine_hours/writing_engine_hours_screen.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/writing_engine_hours/writing_engine_hours_view_model.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/vehicle_main_info_screen.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/vehicle_main_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeMainTabs() {
    return ChangeNotifierProvider(
      create: (context) => MainTabsViewModel(context),
      child: const MainTabsScreen(),
    );
  }

  Widget makeAddingVehicle() {
    return ChangeNotifierProvider(
      create: (_) => AddingVehicleViewModel(),
      child: const AddingVehicleScreen(),
    );
  }

  Widget makeVehicleMainInfo(String vehicleObjectId) {
    return ChangeNotifierProvider(
      create: (_) => VehicleMainInfoViewModel(vehicleObjectId),
      child: const VehicleMainInfoScreen(),
    );
  }

  Widget makeRecommendations() {
    return ChangeNotifierProvider(
      create: (_) => RecommendationsViewModel(),
      child: const RecommendationsScreen(),
    );
  }

  Widget makeRecommendationDetails() {
    return ChangeNotifierProvider(
      create: (_) => RecommendationDetailsViewModel(),
      child: const RecommendationDetailsScreen(),
    );
  }

  Widget makeAddingRecommendation() {
    return ChangeNotifierProvider(
      create: (_) => AddingRecommendationViewModel(),
      child: const AddingRecommendationScreen(),
    );
  }

  Widget makeBreakages() {
    return ChangeNotifierProvider(
      create: (_) => BreakagesViewModel(),
      child: const BreakagesScreen(),
    );
  }

  Widget makeBreakageDetails() {
    return ChangeNotifierProvider(
      create: (_) => BreakageDetailsViewModel(),
      child: const BreakageDetailsScreen(),
    );
  }

  Widget makeAddingBreakage() {
    return ChangeNotifierProvider(
      create: (_) => AddingBreakageViewModel(),
      child: const AddingBreakageScreen(),
    );
  }

  Widget makeHistory() {
    return ChangeNotifierProvider(
      create: (_) => RepairHistoryViewModel(),
      child: const RepairHistoryScreen(),
    );
  }

  Widget makeCompletedRepair() {
    return ChangeNotifierProvider(
      create: (_) => CompletedRepairViewModel(),
      child: const CompletedRepairScreen(),
    );
  }

  Widget makeAddingCompletedRepair() {
    return ChangeNotifierProvider(
      create: (_) => AddingCompletedRepairViewModel(),
      child: const AddingCompletedRepairScreen(),
    );
  }

  Widget makeRoutineMaintenance() {
    return ChangeNotifierProvider(
      create: (_) => RoutineMaintenanceViewModel(),
      child: const RoutineMaintenanceScreen(),
    );
  }

  Widget makeWritingEngineHours() {
    return ChangeNotifierProvider(
      create: (_) => WritingEngineHoursViewModel(),
      child: const WritingEngineHoursScreen(),
    );
  }

  Widget makeObjectMainInfo() {
    return ChangeNotifierProvider(
      create: (_) => ObjectMainInfoViewModel(),
      child: const ObjectMainInfoScreen(),
    );
  }

  Widget makeAddingObject() {
    return ChangeNotifierProvider(
      create: (_) => AddingObjectViewModel(),
      child: const AddingObjectScreen(),
    );
  }
}
