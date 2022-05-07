import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/ui/navigation/main_navigation.dart';

class RecommendationsViewModel extends ChangeNotifier {
  final String _vehicleObjectId;
  final _recommendationService = RecommendationService();
  bool isLoadingProgress = false;

  RecommendationsViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getRecommendationList(context);
  }

  List<Recommendation> _recommendationList = [];
  List<Recommendation> get recommendationList =>
      List.unmodifiable(_recommendationList);

  RecommendationCardWidgetConfiguration
      getRecommendationCardWidgetConfiguration(int index) {
    return RecommendationCardWidgetConfiguration(_recommendationList[index]);
  }

  Future<void> _getRecommendationList(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _recommendationList = await _recommendationService
          .getVehicleRecommendations(vehicleObjectId: _vehicleObjectId);
    } on ApiClientException catch (exception) {
      switch (exception.type) {
        case ApiClientExceptionType.network:
          ErrorDialogWidget.showConnectionError(context);
          break;
        case ApiClientExceptionType.emptyResponse:
          ErrorDialogWidget.showEmptyResponseError(context);
          break;
        case ApiClientExceptionType.other:
          ErrorDialogWidget.showErrorWithMessage(context, exception.message);
          break;
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }

    isLoadingProgress = false;
    notifyListeners();
  }

  void openRecommendationDetailsScreen(
    BuildContext context,
    int index,
  ) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.recommendationDetailsScreen,
      arguments: _recommendationList[index].objectId,
    );
  }

  void openAddingRecommendationScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingRecommendationScreen,
      arguments: _vehicleObjectId,
    );
  }
}

class RecommendationCardWidgetConfiguration {
  late String title;
  late String description;
  late String vehicleNodeIconName;
  RecommendationCardWidgetConfiguration(Recommendation recommendation) {
    title = recommendation.title;
    description = recommendation.description;
    vehicleNodeIconName =
        VehicleNodeNames.getIconName(recommendation.vehicleNode);
  }
}
