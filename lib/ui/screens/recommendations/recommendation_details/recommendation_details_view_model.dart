import 'dart:async';

import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class RecommendationDetailsViewModel extends ChangeNotifier {
  late final _recommendationService = RecommendationService(_vehicleObjectId);

  Recommendation? _recommendation;
  bool isLoadingProgress = false;

  final String _vehicleObjectId;
  final String _recommendationObjectId;
  RecommendationDetailsViewModel(
    this._vehicleObjectId,
    this._recommendationObjectId,
    BuildContext context,
  ) {
    _getRecommendation(context);
    subscribeToRecommendationBox(context);
  }

  Stream<BoxEvent>? recommendationStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToRecommendationBox(BuildContext context) async {
    recommendationStream =
        await _recommendationService.getRecommendationStream();
    subscription = recommendationStream?.listen((event) {
      _getRecommendation(context);
    });
  }

  RecommendationWidgetConfiguration get recommendationWidgetConfiguration =>
      RecommendationWidgetConfiguration(_recommendation);

  Future<void> _getRecommendation(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _recommendation = await _recommendationService
          .getRecommendationFromHive(_recommendationObjectId);
      if (_recommendation == null) {
        ErrorDialogWidget.showDataSyncingError(context);
      }
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

  @override
  Future<void> dispose() async {
    await _recommendationService.dispose();
    await subscription?.cancel();
    super.dispose();
  }
}

class RecommendationWidgetConfiguration {
  late String title;
  late String description;
  late String vehicleNodeIconName;
  late List<String> photosURL;
  RecommendationWidgetConfiguration(Recommendation? recommendation) {
    title = recommendation?.title ?? 'Данные не получены. Обновите страницу';
    description = recommendation?.description ?? '';
    final vehicleNode = recommendation?.vehicleNode ?? '';
    vehicleNodeIconName = VehicleNodeNames.getIconName(vehicleNode);
    photosURL = recommendation?.photosURL ?? [];
  }
}
