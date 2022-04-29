enum ApiClientExceptionType { network, emptyResponse, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException({
    required this.type,
    this.message,
  });
}
