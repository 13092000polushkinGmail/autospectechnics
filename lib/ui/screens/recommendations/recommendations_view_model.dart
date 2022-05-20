import 'dart:async';

import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/recommendation_details_arguments_configuration.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:hive/hive.dart';

class RecommendationsViewModel extends ChangeNotifier {
  late final _recommendationService = RecommendationService(_vehicleObjectId);

  bool isLoadingProgress = false;
  List<Recommendation> _recommendationList = [];

  final String _vehicleObjectId;
  RecommendationsViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getRecommendationList(context);
    subscribeToRecommendationBox(context);
  }

  Stream<BoxEvent>? recommendationStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToRecommendationBox(BuildContext context) async {
    recommendationStream =
        await _recommendationService.getRecommendationStream();
    subscription = recommendationStream?.listen((event) {
      _getRecommendationList(context);
    });
  }

  int get recommendationListLength => _recommendationList.length;

  RecommendationCardWidgetConfiguration?
      getRecommendationCardWidgetConfiguration(int index) {
    if (index < _recommendationList.length) {
      return RecommendationCardWidgetConfiguration(_recommendationList[index]);
    }
  }

  Future<void> _getRecommendationList(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _recommendationList =
          await _recommendationService.getVehicleRecommendationsFromHive();
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
      arguments: RecommendationDetailsArgumentsConfiguration(
        vehicleObjectId: _vehicleObjectId,
        recommendationObjectId: _recommendationList[index].objectId,
      ),
    );
  }

  void openAddingRecommendationScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingRecommendationScreen,
      arguments: _vehicleObjectId,
    );
  }

  @override
  Future<void> dispose() async {
    await _recommendationService.dispose();
    await subscription?.cancel();
    super.dispose();
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
