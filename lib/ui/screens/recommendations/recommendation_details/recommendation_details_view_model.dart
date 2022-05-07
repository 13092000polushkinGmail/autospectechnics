import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';

class RecommendationDetailsViewModel extends ChangeNotifier {
  final String _recommendationObjectId;
  final _recommendationService = RecommendationService();
  Recommendation? _recommendation;
  bool isLoadingProgress = false;

  RecommendationDetailsViewModel(
    this._recommendationObjectId,
    BuildContext context,
  ) {
    _getRecommendation(context);
  }

  RecommendationWidgetConfiguration get recommendationWidgetConfiguration =>
      RecommendationWidgetConfiguration(_recommendation);

  Future<void> _getRecommendation(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _recommendation = await _recommendationService
          .getRecommendation(_recommendationObjectId);
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
