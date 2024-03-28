import 'package:dio/dio.dart';

class ApiException implements Exception {
  List<String> getExceptionMessage(DioException exception) {
    var message = exception.response?.data["message"][0];
    print("message: $message");

    switch (exception.type) {
      case DioExceptionType.badResponse:
        return ["Bad Response Error", "$message"];
      case DioExceptionType.connectionError:
        return ["Connection Error", "$message"];
      case DioExceptionType.connectionTimeout:
        return ["Connection Timeout", "$message"];
      case DioExceptionType.cancel:
        return ["Request  canceled", "$message"];
      case DioExceptionType.receiveTimeout:
        return ["Receive Timeout", "$message"];
      default:
        ["Unknow Error", ""];
    }
    return ["Unknow Error", ""];
  }
}
