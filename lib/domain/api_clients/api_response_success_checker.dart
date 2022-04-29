import 'dart:io';

import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

abstract class ApiResponseSuccessChecker {
  static void checkApiResponseSuccess(ParseResponse apiResponse) {
    if (apiResponse.success) {
    } else if (apiResponse.error?.exception is SocketException) {
      throw ApiClientException(type: ApiClientExceptionType.network);
    } else {
      throw ApiClientException(
        type: ApiClientExceptionType.other,
        message: apiResponse.error?.message,
      );
    }
  }
}
