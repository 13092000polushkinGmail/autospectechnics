import 'dart:io';

import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RecommendationApiClient {
  String _recommendationObjectId = '';
  String get recommendationObjectId => _recommendationObjectId;

  Future<void> saveRecommendationToDatabase({
    required String title,
    required String vehicleNode,
    required String description,
    required bool isCompleted,
  }) async {
    var recommendation = ParseObject(ParseObjectNames.recommendation);
    recommendation.set('title', title);
    recommendation.set('vehicleNode', vehicleNode);
    recommendation.set('description', description);
    recommendation.set('isCompleted', isCompleted);

    final ParseResponse apiResponse = await recommendation.save();

    if (apiResponse.success && apiResponse.results != null) {
      _recommendationObjectId = recommendation.objectId!;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
  }

  Future<void> updateRecommendationInDatabase({
    required String objectId,
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
  }) async {
    var recommendation = ParseObject(ParseObjectNames.recommendation);
    recommendation.objectId = objectId;

    if (title != null) {
      recommendation.set('title', title);
    }

    if (vehicleNode != null) {
      recommendation.set('vehicleNode', vehicleNode);
    }

    if (description != null) {
      recommendation.set('description', description);
    }

    if (isCompleted != null) {
      recommendation.set('isCompleted', isCompleted);
    }

    final ParseResponse apiResponse = await recommendation.save();

    if (apiResponse.success && apiResponse.results != null) {
      _recommendationObjectId = recommendation.objectId!;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
  }
}
