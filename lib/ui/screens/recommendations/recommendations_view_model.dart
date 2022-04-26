import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class RecommendationsViewModel extends ChangeNotifier {

  
  void openRecommendationDetailsScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.recommendationDetailsScreen);
  }

  void openAddingRecommendationScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingRecommendationScreen);
  }
}