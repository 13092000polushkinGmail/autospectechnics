import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:hive/hive.dart';

class RecommendationDataProvider {
  late Future<Box<Recommendation>> _futureBox;
  final String _vehicleId;
  RecommendationDataProvider(this._vehicleId) {
    _futureBox = BoxManager.instance.openBox(
      name: 'recommendation_box_$_vehicleId',
      typeId: 6,
      adapter: RecommendationAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getRecommendationStream() async {
    final box = await _futureBox;
    final recommendationStream = box.watch();
    return recommendationStream;
  }

  Future<void> putRecommendationToHive(Recommendation recommendation) async {
    final box = await _futureBox;
    final recommendationFromHive = box.get(recommendation.objectId);
    if (recommendationFromHive == null ||
        recommendationFromHive != recommendation) {
      await box.put(recommendation.objectId, recommendation);
    }
  }

  Future<void> updateRecommendationInHive({
    required String recommendationId,
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
    Map<String, String>? imagesIdUrl,
  }) async {
    final box = await _futureBox;
    final recommendation = box.get(recommendationId);
    if (recommendation != null) {
      recommendation.updateRecommendation(
        title,
        vehicleNode,
        description,
        isCompleted,
        imagesIdUrl,
      );
      await recommendation.save();
    }
  }

  Future<void> deleteRecommendationFromHive(String recommendationId) async {
    final box = await _futureBox;
    await box.delete(recommendationId);
  }

  Future<List<Recommendation>> getRecommendationsListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<Recommendation?> getRecommendationFromHive(
      String recommendationId) async {
    final box = await _futureBox;
    final recommendation = box.get(recommendationId);
    return recommendation;
  }

  Future<void> deleteUnnecessaryRecommendationsFromHive(
      List<Recommendation> vehicleRecommendationsFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var recommendation in vehicleRecommendationsFromServer) {
      if (keysToDelete.contains(recommendation.objectId)) {
        keysToDelete.remove(recommendation.objectId);
      }
    }
    box.deleteAll(keysToDelete);
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
